;
;	Game device library for the Enterprise 64/128
;	Stefano Bodrato - Mar 2011
;
;	$Id: joystick.asm,v 1.4 2016-06-16 20:23:51 dom Exp $
;

        SECTION code_clib
        PUBLIC    joystick
        PUBLIC    _joystick

        INCLUDE "enterprise.def"

.joystick
._joystick
	;__FASTALL__ : joystick no. in HL
		
	ld	c,l
	ld	b,FN_JOY
	rst   30h
	defb  11

	ld	h,0
	ld	l,c
	ret
