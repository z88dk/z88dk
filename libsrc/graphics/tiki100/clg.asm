;
;       Clear Graphics Screen
;
;       TIKI-100 version by Stefano Bodrato, Sept 2015
;
;	$Id: clg.asm,v 1.2 2016-07-02 09:01:36 dom Exp $
;

	SECTION   code_clib
        PUBLIC    clg
        PUBLIC    _clg
		
	EXTERN	gr_defmod

        EXTERN    swapgfxbk
        EXTERN    swapgfxbk1

        INCLUDE	"graphics/grafix.inc"


.clg
._clg
	DI
	LD     A,16
	LD ($F04D),A	; Video port: copy of the value sent to the video port address 0CH
	OUT   ($0C),A		; set graphics mode
	EI
	
	LD     A,255
	LD     B,1
	CALL   set_palette
	XOR    A
	LD     B,A
	call     set_palette

;	This is the KP/M console CLS sequence 
	LD     E,1
	LD     C,2
	CALL   5		; BDOS
	LD     E,25
	LD     C,2
	JP     5		; BDOS


.set_palette
;	XOR 255		; complement color value
	LD E,A
	LD D,2		; total colors (2 for BW palette)
.palette_loop
	PUSH DE
	LD A,E
	DI
	OUT ($14),A		; Palette register (prepare the color to be loaded)
	OUT ($14),A		; Palette register (do it again to be sure)
	LD 	A,16		; register value for current graphics mode
	ADD B			; palette position
	AND $3F
	LD D,A
	ADD $80
	OUT ($0C),A		; set graphics mode enabling graphics
	LD C,0
.wait_loop
	DEC C
	JP NZ,wait_loop		; wait for HBLANK to get the color copied in the requested palette position
	LD A,D
	OUT ($0C),A			; set graphics mode
	EI
	POP DE
	LD A,B
	ADD D			; move to next palette position
	LD B,A
	CP 16
	JR C,palette_loop
	RET


