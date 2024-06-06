;	TITLE	'ISIS CONSOLE IO'
;	Scott Baker, www.smbaker.com
;
; ISIS system calls
;
	;EXTRN CO
	;EXTRN CI
	;EXTRN PO
	;EXTRN RI
	;EXTRN IOCHK
	EXTRN CSTS
	EXTRN LO
	EXTRN EXIT
	EXTRN ISIS

	PUBLIC COPEN
	PUBLIC CCLOSE
	PUBLIC COUT
	PUBLIC CIN
	PUBLIC CSTAT
	PUBLIC POUT
	PUBLIC ZSOUT

	CSEG

;----------- COPEN: Open :ci: and :co: files -----------

COPEN:	PUSH	PSW
	PUSH	B
	PUSH	D
	PUSH	H
	MVI	C,0
	LXI	D,OBLKCI
	CALL	ISIS
	MVI	C,0
	LXI	D,OBLKCO
	CALL	ISIS
	POP	H
	POP	D
	POP	B
	POP	PSW
	RET
OBLKCI:
	DW	RAFT
	DW	CIFILE
	DW	1	; 1 = input
	DW	0	; 0 = no echo
	DW	RSTAT
CIFILE: DB	':CI:',0
OBLKCO:
	DW	WAFT
	DW	COFILE
	DW	2	; 2 = output
	DW	0	; 0 = no echo
	DW	WSTAT
COFILE: DB	':CO:',0

;----------- CCLOSE: Close :ci: and :co: files -----------

CCLOSE: MVI	C,1
	LXI	D,WBLK
	CALL	ISIS
	MVI	C,1
	LXI	D,RBLK
	CALL	ISIS
	RET

;----------- CSTAT: return console status -----------

;; XXX SMBAKER: This only works when using the video console. Fix it some day.

CSTAT:  CALL	CSTS	; CONSOLE STATUS
	RET		; IF CHR TYPED THEN (A) <- 0FFH ELSE (A) <- 0

;----------- CIN: console in -----------

CIN:	PUSH	B
	PUSH	D
CINAGN:
	MVI	C,3
	LXI	D,RBLK
	CALL	ISIS
	LDA	ACTUAL
	ORA	A
	JZ	CINAGN
	LDA	RBUF
	CPI	0AH
	JZ	CINAGN		; LF YOU ARE NOT WELCOME HERE. GET OUT.

	CPI	60H		; automatic uppercase code
	JM	CIN1
	CPI	7BH
	JP	CIN1
	SUI	20H		; end uppercase code
CIN1:
	
	POP	D
	POP	B
	RET
RBLK:
RAFT:	DS	2
	DW	RBUF
RCNT:	DW	1
	DW	ACTUAL
	DW	RSTAT
ACTUAL: DS	2
RSTAT:	DS	2
RBUF:   DS	2

;----------- COUT: console out -----------


COUT:	PUSH	PSW
	PUSH	B
	PUSH	D
	MOV	A,C
	ANI	07FH		; strip the high bit
	STA	WBUF
	MVI	C,4
	LXI	D,WBLK
	CALL	ISIS
	POP	D
	POP	B
	POP	PSW
	RET
WBLK:
WAFT:	DS	2
	DW	WBUF
WCNT:	DW	1
	DW	WSTAT
WSTAT:  DS	2
WBUF:	DS	2

;----------- POUT: printer out -----------

POUT:	CALL	LO	; PRINTER OUTPUT CHAR IN (C)
	RET

;----------- ZSOUT: print zero terminated string -----------

ZSOUT:	PUSH	PSW
	PUSH	B
ZSOUT0:	LDAX	D		; String in DE. Not Preserved.
	ORA	A
	JZ	ZSOUT1
	MOV	C,A
	CALL	COUT
	INX	D
	JMP	ZSOUT0
ZSOUT1: POP	B
	POP	PSW
	RET

	END
