	XLIB	Read_byte

	LIB Bind_bank_s1


; ******************************************************************************
;
;	Read	byte	at pointer in BHL,A. Return byte in A.
;
;	Design & programming by Gunther Strube,	Copyright	(C) InterLogic	1995
;
;	Register affected on return:
;		..BCDEHL/IXIY
;		AF....../.... af
;
; -----
; $Id: readbyte.asm,v 1.2 2001-04-18 12:43:04 stefano Exp $


.Read_byte		PUSH	HL
				PUSH	DE
				LD	D,0
				LD	E,A
				ADD	HL,DE				; set pointer at offset
				LD	A,B
				CALL	Bind_bank_s1			; page in	bank	temporarily
				LD	E,(HL)				; read byte at	extended address
				CALL	Bind_bank_s1			; restore	prev. binding
				LD	A,E
				POP	DE
				POP	HL
				RET
