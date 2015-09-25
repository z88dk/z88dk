;
;	TIKI-100 graphics routines
;	by Stefano Bodrato, Fall 2015
;
; void __FASTCALL__ gr_defmod(uchar mode)
;
; Set graphics mode
; (1 = BW mode, 2 = four color mode, 3 = 16 color mode)
;
;
;	$Id: gr_defmod.asm,v 1.1 2015-09-25 14:56:02 stefano Exp $
;

PUBLIC gr_defmod


gr_defmod:
	LD A,L
	LD D,0
	LD E,A
	ADD A
	ADD A
	ADD A
	ADD A
	LD ($F04D),A	; Video port: copy of the value sent to the video port address 0CH
	OUT ($0C),A		; graphics mode
	LD HL,$FF87
	ADD HL,DE
	LD A,(HL)
	LD ($FF82),A
	LD A,($F050)	; Left Margin width
	LD HL,($F04E)	; Maximum number of points on a line
	DEC E
	JR NZ,3
	ADD A
	ADD HL,HL
	INC E
	DEC E
	JR NZ,2
	ADD A
	ADD HL,HL
	LD ($FF72),A
	LD ($FF70),HL
	RET
