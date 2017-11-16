;
;	Generic game device library - Galaksija port
;	Stefano Bodrato - 2017
;
;	$Id: joystick.asm $
;


        SECTION code_clib
	PUBLIC    joystick
	PUBLIC    _joystick
	EXTERN	getk

.joystick
._joystick
	;__FASTALL__ : joystick no. in HL

	ld	a,l
	dec	a
	jp  z,arrows

	ld	e,0
	ld	hl,$2020
	ld	a,(hl); zero
	cpl
	rrca
	rl e		; fire
	
	ld	l,$27	;U
	ld	a,(hl)
	cpl
	rrca
	rl e
	
	ld	l,$26	;D
	ld	a,(hl)
	cpl
	rrca
	rl e		; fire
	
	ld	l,$25	;L
	ld	a,(hl)
	cpl
	rrca
	rl e		; fire
	
	ld	l,$28	;R
	ld	a,(hl)
	cpl
	rrca
	rl e		; fire
	
	ld	h,0
	ld	l,e
	ret

	
.arrows
; MOVE_RIGHT 1
; MOVE_LEFT  2
; MOVE_DOWN  4
; MOVE_UP    8
; MOVE_FIRE  16
	
	ld	e,0
	ld	hl,$201F
	ld	a,(hl); space
	cpl
	rrca
	rl e		; fire
	ld	l,27	; $2000 + 27..30: UDLR
	ld b,4
.jloop
	ld 	a,(hl)
	cpl
	rrca
	rl e
	inc hl
	djnz jloop	
	
	ld	h,0
	ld	l,e
	ret

