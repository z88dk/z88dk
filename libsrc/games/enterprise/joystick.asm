;
;	Game device library for the Enterprise 64/128
;	Stefano Bodrato - Mar 2011
;
;	$Id: joystick.asm,v 1.3 2015-01-19 01:32:44 pauloscustodio Exp $
;


        PUBLIC    joystick

        INCLUDE "enterprise.def"

.joystick
	;__FASTALL__ : joystick no. in HL
		
	ld	c,l
	ld	b,FN_JOY
	rst   30h
	defb  11

	ld	h,0
	ld	l,c
	ret
