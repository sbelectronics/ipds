;	TITLE	'ISIS CONSOLE IO'
;	Scott Baker, www.smbaker.com
;
; ISIS system calls
;
	EXTRN CO
	EXTRN CI
	EXTRN CSTS
	EXTRN LO
	EXTRN PO
	EXTRN RI
	EXTRN IOCHK
	EXTRN EXIT
	EXTRN ISIS

	PUBLIC COPEN
	PUBLIC CCLOSE
	PUBLIC COUT
	PUBLIC CIN
	PUBLIC CSTAT

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

	END
