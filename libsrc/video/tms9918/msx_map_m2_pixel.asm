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
;	$Id: msx_map_m2_pixel.asm,v 1.6 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_map_m2_pixel
	PUBLIC	_msx_map_m2_pixel
	
msx_map_m2_pixel:
_msx_map_m2_pixel:

;; ((((y) & ~(7)) << 5) + ((x) & ~(7)))   + ((y) & 7))

	pop	bc
	pop	de	; Y in e
	pop	hl	; X in l
	push	hl
	push	de
	push	bc

	ld	a,l		; X
	and	@11111000
	ld	l,a

	ld	a,e		; Y
	rra
	rra
	rra
	and	@00011111

	ld	h,a		; + ((Y & @11111000) << 5)

	ld	a,e
	and	7
	ld	e,a
	add	hl,de		; + Y&7

	ret
