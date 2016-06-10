;
; 	ANSI Video handling for the Sharp X1
;
; 	BEL - chr(7)   Beep it out
;
;
;	$Id: f_ansi_bel.asm,v 1.6 2016-06-10 23:47:18 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_BEL

.BEPDAT
		defw 142	; C channel frequency:  880Hz
		defb @00111011  ; IO/Noise/tone: B|A|C|B|A|C|B|A
		defb @00001111  ; C channel level


.ansi_BEL

	DI

	CALL	WPSG3

	LD	BC,10000	;10ts
VBLLP:
	DEC	BC	; 6ts
	LD	A,C	; 4ts
	OR	B	; 4ts
	JR	NZ,VBLLP	;12ts

	CALL	WPSG3

	EI
	RET



WPSG3:
	LD	HL,BEPDAT
	LD	A,4
	CALL	WP3SUB
	LD	A,5
	CALL	WP3SUB
	LD	A,7
	CALL	WP3SUB
	LD	A,10
	CALL	WP3SUB
	ld	a,(BEPDAT+3)
	xor	00001111B
	ld (BEPDAT+3),a
	RET

WP3SUB:	LD	BC,1C00H
	OUT	(C),A
	OUTI   ; (increments HL)
	RET


