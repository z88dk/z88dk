
	MODULE	joystick
	SECTION	code_clib
	PUBLIC	joystick
	PUBLIC	_joystick
	EXTERN	joystick_inkey

; 0 = #define MOVE_RIGHT 1
; 1 = #define MOVE_LEFT  2
; 2 = #define MOVE_DOWN  4
; 3 = #define MOVE_UP    8
; 4 = #define MOVE_FIRE  16
; 5 = #define MOVE_FIRE2 32


; hl = 1 - player 1 joystick
;    = 2 - player 2 joystick
;    = 3 - qaop
;    = 4 - 8246
;    = 5 - hjkl
;    = 6 - cursors

; Ports 10, 11, 12 = J1 13, 14, 15 = J2

joystick:
_joystick:
	ld	h,10
	ld	a,l
	cp	1
	jr	z,read_joystick
	ld	h,13
	cp	2
	jr	z,read_joystick
	sub	2
	jp	joystick_inkey

read_joystick:
	ld	bc,0xf4
	ld	l,0		;Result
	; h = starting port to read
	out	(c),h
	in	a,(c)	;_0
	rrca
	jr	nc,not_u
	set	3,l
not_u:
	rrca
	jr	nc, not_ul
	set	3,l
	set	1,l
not_ul:
	rrca
	jr	nc, not_l
	set	1,l
not_l:
	rrca
	jr	nc, not_f
	set	4,l
not_f:
	inc	h	
	out	(c),a
	in	a,(c)	; _1
	rrca
	jr	nc, not_dl
	set	2, l
	set	1, l
not_dl:
	rrca
	jr	nc, not_ur
	set	3,l
	set	0,l
not_ur:
	inc	h
	out	(c),h
	in	a,(c)	; _2
	rrca
	jr	nc,not_d
	set	2,l
not_d:
	rrca
	jr	nc,not_dr
	set	2,l
	set	0,l
not_dr:
	rrca
	jr	nc,not_r
	set	0,l
not_r:
	rrca
	jr	nc,not_f2
	set	5,l
not_f2:
	ld	h,0
	ret

