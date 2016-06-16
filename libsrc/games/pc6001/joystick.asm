;
;	Game device library for the PC6001
;       Stefano Bodrato - 3/12/2007
;
;	$Id: joystick.asm,v 1.3 2016-06-16 20:23:52 dom Exp $
;

	SECTION code_clib
        PUBLIC    joystick
        PUBLIC    _joystick


.joystick
._joystick
	;__FASTCALL__ : joystick no. in HL
		
	ld	a,l

	dec	a
	ret      nz

	CALL	$1061
	ld	l,a
	xor	a
	rl l	; fire 1 (SPACE)
	rla
	rr l
	
	rr l	; fire 2 (SHIFT)
	rla

	rr l

	rr l	; up
	rla
	
	rr l	; down
	rla

	rr l	; right

	rr l	; left
	rla

	rl	l	; right
	rla

	ld	h,0
	ld	l,a
	
	ret

