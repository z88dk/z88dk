;
; Joystick handling for the Colecovision
;
;

		MODULE	joystick
		SECTION	code_clib
		PUBLIC	joystick
		PUBLIC	_joystick

; Ports 0xfc and 0xff
;
; Bit 0 - up
; Bit 1 - Right
; Bit 2 - Down
; Bit 3 - Left
; Bit 4 = Fire 2
; Bit 5 = Fire 3
; Bit 6 = Fire 0
; Bit 7 = Fire 1
;
;
; Writing to port 0x80 tenkey = true
; Writing to port 0xc0 tenkey = false
;
; If tenkey is false then reading joystick on ports
;

; Output
; 0 = #define MOVE_RIGHT 1
; 1 = #define MOVE_LEFT  2
; 2 = #define MOVE_DOWN  4
; 3 = #define MOVE_UP    8
; 4 = #define MOVE_FIRE  16
; 5 = #define MOVE_FIRE2 32

joystick:
_joystick:
	ld	h,0
	ld	a,1
	out	($c0),a		;We're gonna read the joypads
	bit	0,l
	jr	z,handle_j2
	in	a,($fc)
	jr	parse_joystick
handle_j2:
	in	a,($ff)
parse_joystick:
	ld	l,0
	rrca
	jr	c,not_up
	set	3,l
not_up:
	rrca
	jr	c,not_right
	set	0,l
not_right:
	rrca
	jr	c,not_down
	set	2,l
not_down:
	rrca
	jr	c,not_left
	set	1,l
not_left:
	rrca
	jr	c,not_fire2
	set	6,l
not_fire2:
	rrca
	jr	c,not_fire3
	set	7,l
not_fire3:
	rrca
	jr	c,not_fire
	set	4,l
not_fire:
	rrca
	ret	c
	set	5,l
	ret
