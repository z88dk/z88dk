;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	Public pattern for variable intensity dither
;
;	$Id: dithpat.asm,v 1.1 2009-01-07 09:50:15 stefano Exp $
;


	XLIB	dithpat
	

dithpat:
	
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
