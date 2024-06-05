;
; ISIS system calls
;
	EXTRN CO
	EXTRN CI
	EXTRN CSTS
	EXTRN EXIT
;
;
;-------------------------------------------------------
;
;	ORG	3A80H
	CSEG
ORIG:	LXI	SP,STCKE
	MVI	C,'H'
	CALL	CO
	MVI	C,'E'
	CALL	CO
	MVI	C,'L'
	CALL	CO
	MVI	C,'L'
	CALL	CO
	MVI	C,'O'
	CALL	CO
	MVI	C,','
	CALL	CO
	MVI	C,' '
	CALL	CO
	MVI	C,'W'
	CALL	CO
	MVI	C,'O'
	CALL	CO
	MVI	C,'R'
	CALL	CO
	MVI	C,'L'
	CALL	CO
	MVI	C,'D'
	CALL	CO
	MVI	C,0DH
	CALL	CO
	MVI	C,0AH
	CALL	CO
	CALL    EXIT

STCKA:  DS	128
STCKE:  DS	4

	END	ORIG
