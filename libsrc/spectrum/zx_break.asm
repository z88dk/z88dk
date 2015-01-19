;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 14/09/2006
;	Improved by Antonio Schifano, Dec 2008
;
;	int zx_break();
;
;	Check if the CAPS-SPACE (BREAK) key is being pressed
;       ( 1 = pressed; 0 = not pressed )
;
;	Caps-shift + space version A.Schifano 29/12/2008
;
;	$Id: zx_break.asm,v 1.3 2015-01-19 01:33:11 pauloscustodio Exp $
;

	PUBLIC	zx_break
	
zx_break:
	ld	hl,0	; assume break is not pressed
	ld	a,$7f
	in	a,($fe)
	rra
	ret	c	; space not pressed
	ld	a,$fe
	in	a,($fe)
	rra
	ret	c
	inc	l	; both shift & space pressed, 
	ret
