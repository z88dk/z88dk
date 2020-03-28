;
; Joystick handling for the SC-3000 and SG-1000
;
;

		MODULE	joystick
		SECTION	code_clib
		PUBLIC	joystick
		PUBLIC	_joystick
		EXTERN	joystick_inkey


; Port $dd:
; Bit 3 = J2-2
; Bit 2 = J2-1
; Bit 1 = J2-Right
; Bit 0 = J2-Left

; Port $dc
; Bit 7 = J2-Down
; Bit 6 = J2-Up
; Bit 5 = J1-2
; Bit 4 = J1-1
; Bit 3 = J1-Right
; Bit 2 = J1-Left
; Bit 1 = J1-Down
; Bit 0 = J1-Up

; Output
; 0 = #define MOVE_RIGHT 1
; 1 = #define MOVE_LEFT  2
; 2 = #define MOVE_DOWN  4
; 3 = #define MOVE_UP    8
; 4 = #define MOVE_FIRE  16
; 5 = #define MOVE_FIRE2 32

joystick:
_joystick:
	ld	a,l
	cp	3
	jr	nc,handle_keyboard
	ld	h,0
	in	a,($de)		;Select row 7 (only needed on SC-3000, no effect on SG-1000)
	and	248
	or	7
	out	($de),a
	in	a,($dd)
	cpl
	ld	e,a
	in	a,($dc)
	cpl
	ld	d,a
	bit	0,l
	jr	nz,handle_j1

; Handle Joystick 2
	ld	a,e		;Fire button
	rlca
	rlca
	and	@00110000
	ld	l,a
	bit	0,e		;left?
	jr	z,not_left_j2
	set	1,l
not_left_j2:
	bit	1,e		;right?
	jr	z,not_right_j2
	set	0,l
not_right_j2:
	bit	7,d		;down?
	jr	z,not_down_j2
	set	2,l
not_down_j2:
	bit	6,d		;up?
	ret	z		
	set	3,l
	ret

handle_j1:
	ld	a,d		;Handle fire
	and	@00110000
	ld	l,a
	bit	3,d		;right?
	jr	z,not_right_j1
	set	0,l
not_right_j1:
	bit	2,d		;left?
	jr	z,not_left_j1
	set	1,l
not_left_j1:
	bit	1,d		;down?
	jr	z,not_down_j1
	set	2,l
not_down_j1:
	bit	0,d		;up?
	ret	z
	set	3,l
	ret

handle_keyboard:
	sub	2
	jp	joystick_inkey
