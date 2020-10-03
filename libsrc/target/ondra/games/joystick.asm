
	SECTION	code_clib

	PUBLIC	joystick
	PUBLIC	_joystick
	EXTERN	joystick_inkey

joystick:
_joystick:
	;__FASTCALL__ joystick number in hl
	ld	a,l
	dec	a
	jp	nz,joystick_inkey
; Read the joystick port
	ld	a,@111
	out	(3),a
	ld	a,($e009)
	cpl
	ld	c,a
	ld	a,@001
	out	(3),a

; Ondra: Bit 0 = down
;        Bit 1 = left
;        Bit 2 = up
;        Bit 3 = fire
;        Bit 4 = right

; z88dk: 
; #define MOVE_RIGHT 1
; #define MOVE_LEFT  2
; #define MOVE_DOWN  4
; #define MOVE_UP    8
; #define MOVE_FIRE  16
	ld	hl,0
	ld	a,c
	rrca		;Down
	jr	nc,not_down
	set	2,l
not_down:
	rrca		;Left
	jr	nc,not_left
	set	1,l
not_left:
	rrca		;Up
	jr	nc,not_up
	set	3,l
not_up:
	rrca		;Fire
	jr	nc,not_fire
	set	4,l
not_fire:
	rrca		;Right
	ret	nc
	set	0,l
	ret
