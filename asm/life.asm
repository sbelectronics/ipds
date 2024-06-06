$macrofile

;
;
;-------------------------------------------------------

COLDEC	MACRO                                ; decrement column by 1
	mov a,l
	ani 0C0H
	mov c,a                              ; C has bits 7,6 of L
	mov a,l
	sui 1
	ani 03FH
	ora c
	mov l,a
	ENDM

COLINC	macro                                ; increment column by 1
	mov a,l
	ani 0C0H
	mov c,a                              ; C has bits 7,6 of L
	mov a,l
	adi 1
	ani 03FH
	ora c
	mov l,a
	endm

ROWDEC	macro                                ; decrement row by 1
	local	nowrap
	mov a,l
	sui 040H
	mov l,a
	mov a,h
	sbi 0H
	cpi CONPAGE-1
	jnz nowrap
	mvi a,CONPAGE+4
nowrap:	mov h,a
	endm

ROWINC	macro                                ; increment row by 1
	local	nowrap
	mov a,l
	adi 040H
	mov l,a
	mov a,h
	aci 0H
	cpi CONPAGE+5
	jnz nowrap
	mvi a,CONPAGE
nowrap:	mov h,a
	endm

PRSPACE	macro
	push b
	;push d
	push h
	mvi c,' '
	call CO
	pop h
	;pop d
	pop b
	endm

PRSTAR	macro
	push b
	;push d
	push h
	mvi c,'*'
	call CO
	pop h
	;pop d
	pop b
	endm

;
; ISIS system calls
;
	EXTRN EXIT
	EXTRN CO

	STKLN	100H				; Size of stack segment

CONPAGE EQU	080H				; start the playfield at 0x8000
CONNEXT EQU	088H

	CSEG

ORIG:	LXI	SP,STACK			; Setup initial stack
	LXI	D, BANNER			; Load Hello String
	CALL	ZSOUT				; Print string

	;; the banner will immediately be overwritten

	CALL	RESET

	CALL	HOME
	CALL	COPY
	CALL	EXIT

FOREVR:
	CALL	FULL
	CALL	HOME
	CALL	COPY
	JMP	FOREVR

	CALL	EXIT				; Exit to ISIS

BANNER:	DB	'Conway!', 0DH, 0AH
	DB	'Scott Baker', 0DH, 0AH
	DB	'http://www.smbaker.com/', 0DH, 0AH
	DB	0

;-------------- HOME -----------------

HOME:	MVI	C,01BH
	CALL	CO
	MVI	C,'H'
	CALL	CO
	RET

;-------------- RESET ----------------

RESET:	mvi h,CONPAGE
	mvi l,0
	mvi c,00EH                           ; Clear 8 blocks on the first page and 6 on the second
RESETL:
	mvi m,0
	inr l
	jnz RESETL
	inr h

	dcr c
	jnz RESETL

	;; load a glider

	mvi h,CONNEXT	                     ; put the glider in the new screen
	mvi l,001H
	mvi m,1
	mvi l,042H
	mvi m,1
	mvi l,080H
	mvi m,1
	mvi l,081H
	mvi m,1
	mvi l,082H
	mvi m,1
	ret

;------------ COPY ------------
COPY:
	mvi h, CONNEXT
	mvi l,0
	call COPBLK
	call COPBLK
	call COPBLK
	call COPBLK
	call COPBLK
	;call COPBLK
	ret

COPBLK:
	mvi d,04H                               ; 4 rows
COPLPR:
	mvi c,040H                              ; 64 columns
COPLPC:
	mov a,m
	ora a
	jnz COPALV
	PRSPACE
	mvi b,0
	jmp COPSET
COPALV:
	PRSTAR
	mvi b,1
COPSET:
	mov a,h
	ani 0F7H                                 ; copy to old
	mov h,a
	mov m,b
	ori 08H                                 ; set H back to new
	mov h,a
	inr l
	jnz COPNW
	inr h
COPNW:
	dcr c
	jnz COPLPC
	mvi c,0DH
	call CO
	mvi c,0AH
	call CO
	dcr d
	jnz COPLPR
	ret

;----------- FULL ------------

FULL:
	mvi d, CONPAGE
	mvi e, 0
	call BLOCK
	call BLOCK
	call BLOCK
	call BLOCK
	call BLOCK
	;call BLOCK
	ret

;----------- BLOCK ------------

BLOCK:
BLOCKL:
;;           mov a,e
;;           out LEDPORT                          ; for debugging

	mov h,d
	mov l,e
	mov a,m

	ora a
	jz dead
ALIVE:
	call CELL
	mov a,b
	cpi 2                                ; exactly 2 neighbors?
	jz SALIVE
	cpi 3                                ; exactly 2 neighbors?
	jz SALIVE
	mvi b,0
	jmp UPDATE
SALIVE: mvi b,1
	jmp UPDATE
DEAD:
	call CELL
	mov a,b
	cpi 3                                ; are there exactly 3 neighbors
	jnz SDEAD
	mvi b,1
	jmp UPDATE
SDEAD:  mvi b,0
UPDATE:                                         ; b==0 if dead, b==1 if alive
	mov a,d
	ori 08H                              ; go forward 2K
	mov h,a
	mov l,e
	mov m,b                              ; store the new cell

	inr e
	jnz BLOCKL                      ; do all 256 entries in the block

	inr d                                ; at the end of the loop, we wrapped so increment d

	ret

;----------- CELL ------------	

CELL:
	coldec                               ; (R-1, C-1)
	rowdec
	mov a,m
	mov b,a

	colinc                               ; (R-1, C)
	mov a,m
	add b
	mov b,a

	colinc                               ; (R-1, C+1)
	mov a,m
	add b
	mov b,a

	rowinc                               ; (R, C+1)
	mov a,m
	add b
	mov b,a

	coldec                               ; (R, C-1)
	coldec
	mov a,m
	add b
	mov b,a

	rowinc                               ; (R+1,C-1)
	mov a,m
	add b
	mov b,a

	colinc                               ; (R+1, C)
	mov a,m
	add b
	mov b,a

	colinc                               ; (R+1, C+1)
	mov a,m
	add b
	mov b,a
	ret

;----------- ZSOUT: print zero terminated string -----------

ZSOUT:	PUSH	PSW
	PUSH	B
ZSOUT0:	LDAX	D		; String in DE. Not Preserved.
	ORA	A
	JZ	ZSOUT1
	MOV	C,A
	CALL	CO
	INX	D
	JMP	ZSOUT0
ZSOUT1: POP	B
	POP	PSW
	RET

	END	ORIG
