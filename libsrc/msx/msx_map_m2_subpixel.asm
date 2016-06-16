;
;	MSX specific routines
;
;	Original concept:
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;	asm optimization by Stefano Bodrato
;
;	extern int msx_map_m2_subpixel(int x, int y);
;
;	Compute mask of a pixel given its number
;
;	$Id: msx_map_m2_subpixel.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_map_m2_subpixel
	PUBLIC	_msx_map_m2_subpixel
	

msx_map_m2_subpixel:
_msx_map_m2_subpixel:
	
	ld	a,7
	and	l
	
	ld	b,a
	ld	a,128
	
	jr	z,firstbit

rotate:	rrca
	djnz	rotate

firstbit:
	ld	h,0
	ld	l,a

	ret
