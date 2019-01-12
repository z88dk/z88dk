
        MODULE  joystick
        SECTION code_clib
        PUBLIC  joystick
        PUBLIC  _joystick
        EXTERN  joystick_inkey

; 0 = #define MOVE_RIGHT 1
; 1 = #define MOVE_LEFT  2
; 2 = #define MOVE_DOWN  4
; 3 = #define MOVE_UP    8
; 4 = #define MOVE_FIRE  16
; 5 = #define MOVE_FIRE2 32

; Joystick on port 0
; MSB LSB
; . . F2 F1 R L D U

joystick:
_joystick:
	in	a,(0)
	ld	hl,0
	rrca
	jr	c,not_up
	set	3,l
not_up:
	rrca
	jr	c,not_down
	set	2,l
not_down:
	rrca
	jr	c,not_left
	set	1,l
not_left:
	rrca
	jr	c,not_right
	set	0,l
not_right:
	rrca
	jr	c,not_f1
	set	4,l
not_f1:
	rrca
	ret	c
	set	5,l
	ret

