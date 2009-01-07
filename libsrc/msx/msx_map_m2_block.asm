;
;	MSX specific routines
;
;	Original concept:
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;	asm version by Stefano Bodrato
;
;	extern int msx_map_m2_block(int x, int y);
;
;	Compute address of a gfx block position on VRAM (mode 2)
;
;	$Id: msx_map_m2_block.asm,v 1.1 2009-01-07 09:50:15 stefano Exp $
;

	XLIB	msx_map_m2_block
	
msx_map_m2_block:
	pop	bc
	pop	hl	; Y
	pop	de	; X
	push	de
	push	hl
	push	bc
	
	ld	c,l	; this will be useful in map_pixel
	
	ld	a,@11111000	; Y = Y & ~(7)
	and	l
	ld	l,a

	ld	a,@11111000	; X = X & ~(7)
	and	e
	ld	e,a

	rl	l		; (Y <<5)
	rl	h
	
	rl	l
	rl	h
	
	rl	l
	rl	h
	
	rl	l
	rl	h
	
	rl	l
	rl	h
	
	add	hl,de		; + X

	ret
