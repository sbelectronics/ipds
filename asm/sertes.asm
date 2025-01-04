;	TITLE	'serial test`
;	Scott Baker, www.smbaker.com
;
;	Test for sbx-351 serial board
;
;
; ISIS system calls
;
	EXTRN COUT
	EXTRN CIN
	EXTRN ZSOUT
	EXTRN COPEN
	EXTRN EXIT

	EXTRN PSPACE
	EXTRN PHEXA
	EXTRN PCRLF

CTR0    EQU	0A8H		;COUNTER #0
CTR1	EQU	0A9H 		;COUNTER #1 
CTR2	EQU	0AAH 		;COUNTER #2
TMCP 	EQU 	0ABH		;COMMAND FOR INTERVAL TIMER 

B9600	EQU	08 		;COUNT FOR 9600 BAUD TIMER (9600 x 16 = 153,600)
C2M3	EQU	0B6H 		;counter 2 mode three (square wave)

;       8251 UART PORTS
CNCTL	EQU	0A1H 		;CONSOLE USART CONTROL PORT 
CONST	EQU	0A1H 		;CONSOLE STATUS INPUT PORT
CNIN	EQU	0A0H 		;CONSOLE INPUT PORT 
CNOUT	EQU	0A0H 		;CONSOLE OUTPUT PORT 

TRDY    EQU     001H        	;Transmit ready
RRDY	EQU 	002H		;RECEIVER BUFFER STATUS READY
MODE	EQU 	04EH		;MODE SET FOR USART 1 stop no parity 8 bit 16x clock

CMD	EQU	036H 		;INITIALIZATION
RESURT 	EQU 	037H		;RESET ERROR AND SET DTR. 
RSTUST 	EQU 	040H		;USART MODE RESET COMMAND

CR      EQU      0DH            ;CARRIAGE RETURN
LF      EQU      0AH            ;LINE FEED

	STKLN	100H				; Size of stack segment

	CSEG	

ORIG:	LXI	SP, STACK

;set up timer for baud rate clock generator
	MVI 	A,C2M3			;INITIALIZE COUNTER #2 FOR BAUD RATE 
	OUT 	TMCP			;OUTPUT COMMAND WORD TO INTERVAL TIMER 
	LXI 	H,B9600			;LOAD BAUD RATE FACTOR 
	MOV 	A,L			;LEAST SIGNIFICANT WORD FOR CTR2 
	OUT 	CTR2			;OUTPUT WORD TO CTR 2 
	MOV 	A,H			;MOST SIGNIFICANT WORD FOR CTR2 
	OUT 	CTR2			;OUTPUT WORD TO CTR2
	;JMP	SKPSET
;set up UART
	MVI	A,00			;USART SET UP MODE 
	OUT	CNCTL			;OUTPUT MODE 
	OUT	CNCTL			;OUTPUT MODE 
	OUT	CNCTL			;OUTPUT MODE 
	MVI	A,040H  		;USART RESET
	OUT	CNCTL			;OUTPUT MODE 
			
	MVI	A,04EH			;USART SET UP MODE. 
	OUT	CNCTL			;OUTPUT MODE 
	MVI 	A,037H			;
	OUT 	CNCTL			;OUTPUT COMMAND WORD TO USART
SKPSET:

	LXI	H, BANNER
	CALL	SERSTR

RDLP:
	CALL	SERCIN
	CPI	'X'
	JZ	DONE
	CPI	'x'
	JZ	DONE
	CALL	SERCHR
	JMP	RDLP

	;CALL	COPEN
	;IN	CONST
	;CALL	PHEXA
	;CALL	PCRLF
	;IN	CNIN
	;CALL	PHEXA
	;CALL	PCRLF
	;MVI	A, 'A'
	;OUT	CNOUT


	;IN	CONST
	;CALL	PHEXA
	;CALL	PCRLF

DONE:
	CALL 	EXIT

BANNER: DB	CR, LF
	DB	'Serial Test', CR, LF
	DB	'Press X to quit', CR, LF + 080H

; SERCHR: print character in A to serial port

SERCHR:	PUSH    B		;save BC
        PUSH    PSW
	MOV     C,A
SEROUT:	IN 	CONST	        ;GET STATUS OF CONSOLE 
        ANI 	TRDY	        ;SEE IF TRANSMITTER READY 
	JZ  	SEROUT	        ;NO - WAIT till ready
	MOV 	A,C		;move CHARACTER TO A REG 
	OUT 	CNOUT	        ;SEND Character TO CONSOLE 
	POP     PSW
	POP     B               ;restore BC
	RET

SERCIN: PUSH   H				;SAVE REGISTERS
        PUSH   D
        PUSH   B 
CINLP:	IN 	CONST		;GET STATUS OF CONSOLE 
	ANI 	RRDY		;CHECK FOR RECEIVER BUFFER READY 
	JZ 	CINLP		;WAIT till recieved 
	IN      CNIN		;GET CHARACTER 
        POP    B                ;RESTORE REGISTERS
        POP    D
        POP    H
        RET                      ;RETURN

; SERSTR: print string in HL to serial port

SERSTR: PUSH    PSW             ;SAVE PSW
        PUSH    H               ;SAVE HL
MNXT:   MOV     A,M             ;GET A CHARACTER
        CPI     0FFH            ;CHECK FOR 377Q/0FFH/-1 EOM
        JZ      MDONE           ;DONE IF OFFH EOM FOUND
        ORA     A               ;TO CHECK FOR ZERO TERMINATOR
        JZ      MDONE           ;DONE IF ZERO EOM FOUND
        RAL                     ;ROTATE BIT 8 INTO CARRY
        JC      MLAST           ;DONE IF BIT 8 = 1 EOM FOUND
        RAR                     ;RESTORE CHAR
        CALL    SERCHR          ;TYPE THE CHARACTER
        INX     H               ;BUMP MEM VECTOR
        JMP     MNXT            ;AND CONTINUE
;
MLAST:  RAR                     ;RESTORE CHARACTER
        ANI     7FH             ;STRIP OFF BIT 8
        CALL    SERCHR          ;TYPE THE CHARACTER & EXIT
;
MDONE:  POP     H               ;RESTORE HL
        POP     PSW             ;AND PSW
        RET                     ;EXIT TO CALLER

	END	ORIG
