;
;	Game device library for the PC6001
;       Stefano Bodrato - 3/12/2007
;
;	$Id: joystick.asm,v 1.2 2015-01-19 01:32:44 pauloscustodio Exp $
;

        PUBLIC    joystick


.joystick
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

