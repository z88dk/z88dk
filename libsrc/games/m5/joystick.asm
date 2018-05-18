;
;	Game device library for the Sord M5
;       Stefano Bodrato - 2018
;
;	$Id: joystick.asm $
;

	SECTION code_clib
        PUBLIC    joystick
        PUBLIC    _joystick



.joystick
._joystick
	;__FASTCALL__ : joystick no. in HL
		
	ld	a,l

	ld	hl,0
	dec	a
	jr      nz,no_cursor

	in a,($37)	; joystick
	; DLUR	-> UDLR
	rra		;Right
	rra		;Up
	rl d
	rra		;Left
	rl l	
	rra
	rl e	;Down
	
	rr d	;Up
	rla
	rr e	;Down
	rla
	rr l	;Left
	rla
	rla		;Right
	and $0f
	
	ld	e,a
	in a,($30)	; keyboard row scan
	and $40	; mask the SPACE key
	;FUDLR
	rra
	rra		; FIRE
	or e
	ld	l,e
	
.no_cursor
	ret

