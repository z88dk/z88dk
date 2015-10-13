;
;	TIKI-100 graphics routines
;	by Stefano Bodrato, Fall 2015
;
;   Palette is always 16 colors long, 'len' is the number
;   of colors being passed, which will be copied many times
;
; void __FASTCALL__ gr_setpalette(int len, char *palette)
;
;
;	$Id: gr_setpalette.asm,v 1.1 2015-10-13 19:56:30 stefano Exp $
;

PUBLIC gr_setpalette

EXTERN gr_currentmode

gr_setpalette:
	pop bc
	pop hl
	pop de
	push de
	push hl
	push bc
	
	ld  d,e		; len
	ld b,0
set_loop:
	ld a,(hl)
	push hl
	push bc
	push de
	call do_set
	pop de
	pop bc
	pop hl
	inc hl
	inc b
	dec d
	jr nz,set_loop
	
	ret
	
	
.do_set
	XOR 255		; complement color value
	LD E,A
;	LD D,2		; total colors (2 for BW palette)
.palette_loop
	PUSH DE
	LD A,E
	DI
	OUT ($14),A		; Palette register (prepare the color to be loaded)
	OUT ($14),A		; Palette register (do it again to be sure)
	LD 	A,(gr_currentmode)		; register value for current graphics mode
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
