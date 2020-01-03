;
;	Generic game device library - VG-5000 port
;	Stefano Bodrato - 2014
;
;	$Id: joystick.asm,v 1.3 2016-06-16 19:33:59 dom Exp $
;
; 	Joystick 1 on 0x07
; 	Joystick 2 on 0x08
;
;	Active low:
;
;	0x01 = up
;	0x02 = right
;	0x04 = down
; 	0x08 = left
;	0x10 = fire
;
; 

        SECTION code_clib
	PUBLIC    joystick
	PUBLIC    _joystick
	EXTERN	getk
	EXTERN	joystick_inkey

.joystick
._joystick
	;__FASTALL__ : joystick no. in HL
	ld	a,l
	cp	3
	jr	nc,try_keyboard
	ld	bc,0x07
	cp	1
	jr	nz,read_joystick
	inc	bc	; bc = 0x08
read_joystick:
	ld	hl,0	;return value
	in	a,(c)
	rrca
	jr	c,no_up
	set	3,l
no_up:
	rrca
	jr	c,no_right
	set	0,l
no_right:
	rrca
	jr	c,no_down
	set	2,l
no_down:
	rrca
	jr	c,no_left
	set	1,l
no_left:
	rrca
	ret	c
	set	4,l	;fire
	ret

try_keyboard:
	sub	2
	jp	joystick_inkey
