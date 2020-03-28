;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	Public pattern for variable intensity dither
;
;	$Id: dithpat.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

	SECTION rodata_clib
	PUBLIC	_dithpat
	

_dithpat:
	
	defb	00000000B
	defb	00000000B

	defb	00000000B
	defb	10101010B

	defb	01010101B
	defb	10101010B

	defb	11111111B
	defb	10101010B

	defb	11111111B
	defb	11111111B
