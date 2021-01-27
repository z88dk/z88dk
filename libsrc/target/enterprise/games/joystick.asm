;
;	Game device library for the Enterprise 64/128
;	Stefano Bodrato - Mar 2011
;
;	$Id: joystick.asm,v 1.4 2016-06-16 20:23:51 dom Exp $
;

        SECTION code_clib
        PUBLIC    joystick
        PUBLIC    _joystick

        INCLUDE "target/enterprise/def/enterprise.def"

.joystick
._joystick
	;__FASTCALL__ : joystick no. in HL

	; L = 0: internal joystick
	; L = 1: external 1
	; L = 2: external 2

	ld    a,69h     ; keyboard channel
	ld    c,l       ; joystick number
	ld    b,FN_JOY  ; sub-function: read joystick directly
	rst   30h       ; EXOS
	defb  11        ; special function

	; b0: right
	; b1: left
	; b2: down
	; b3: up
	; b4: fire

	ld	h,0
	ld	l,c
	ret
