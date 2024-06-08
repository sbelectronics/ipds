;	TITLE	'print utils`
;	Scott Baker, www.smbaker.com
;
; 	Utils for printing hex digits and similar
;
; ISIS system calls
;
	EXTRN COUT

	PUBLIC	PSPACE
	PUBLIC	PCRLF
	PUBLIC	PHEXA

	CSEG

	; --------- print a space ---------

PSPACE:	PUSH	PSW
	PUSH	B
	PUSH	D
	MVI	C,' '
	CALL	COUT
	POP	D
	POP	B
	POP	PSW
	RET

	; --------- print CR/LF ---------

PCRLF:	PUSH	PSW
	PUSH	B
	PUSH	D
	MVI	C,0DH
	CALL	COUT
	MVI	C,0AH
	CALL	COUT
	POP	D
	POP	B
	POP	PSW
	RET

	; --------- print 8-bit hex in A register ---------

PHEXA:	push psw
	push b
	push d
	mov b,a
	rrc                     ; rotate most significant nibble into lower 4 bits
	rrc
	rrc
	rrc
	call HEXASC          ; convert the most significand digit to ascii
	mov c,a
	call COUT
	mov a,b                 ; restore
	call HEXASC
	mov c,a
	call COUT
	pop d
	pop b
	pop psw
	ret

	; --------- helper: convert nibble in A to hex character ---------

HEXASC:	push b
	ani 0FH                 ; mask all but the lower nibble
	mov b,a                 ; save the nibble in E
	sui 10
	mov a,b
	jc HEXAS1           ; jump if the nibble is less than 10
	adi 7                   ; add 7 to convert to A-F
HEXAS1:	adi 30H
	pop b
	ret

	END
