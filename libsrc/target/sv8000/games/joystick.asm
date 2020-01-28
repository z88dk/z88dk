
	SECTION	code_clib

	PUBLIC	joystick
	PUBLIC	_joystick


; Joystick directions are on 8255 port a (0x80)
;
; Fire buttons # on ROW2
; Fire button * on ROW0


joystick:
_joystick:
	ld	c,$01		;Bit for fire
	in	a,($80)
	dec	l
	jr	z,read_it
	; Joystick 2 here, rotatel
	ld	c,$10
	rrca
	rrca
	rrca
	rrca
read_it:
	ld	hl,0
; Port is: RLDU RLDU
; Games is: #define MOVE_RIGHT 1
; #define MOVE_LEFT  2
; #define MOVE_DOWN  4
; #define MOVE_UP    8
; #define MOVE_FIRE  16
	rrca
	jr	c,not_up
	set 	3,l
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
	;Now to read a fire button, we'll use # as the fire button
	; Write to port C on the 8255
	ld	a,$bb
	out	($82),a
	in	a,($81)	;Read from port B
	cpl
	and	c
	ret	z
	set	4,l	;And fire is pressed
	ret



