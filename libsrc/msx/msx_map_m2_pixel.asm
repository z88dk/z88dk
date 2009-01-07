;
;	MSX specific routines
;
;	Original concept:
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;	asm optimization by Stefano Bodrato
;
;	extern int msx_map_m2_pixel(int x, int y);
;
;	Compute address of a gfx block position on VRAM (mode 2)
;
;	$Id: msx_map_m2_pixel.asm,v 1.1 2009-01-07 09:50:15 stefano Exp $
;


	XLIB	msx_map_m2_pixel
	LIB	msx_map_m2_block
	
msx_map_m2_pixel:
	
	pop	af
	ex	af,af	; ret addr

	call	msx_map_m2_block

	ld	a,7	; Y & 7
	and	c
	ld	e,a

	add	hl,de		; +
	
	ex	af,af
	push	af	; ret addr

	ret
