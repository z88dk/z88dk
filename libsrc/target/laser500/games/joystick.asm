;
;	Game device library for the Laser 500
;


; up    = ~(inp(&h2b) &  1)
; down  = ~(inp(&h2b) &  2)
; left  = ~(inp(&h2b) &  4)
; right = ~(inp(&h2b) &  8)
; fire  = ~(inp(&h2b) & 16)
; fire2 = ~(inp(&h27) & 16)

	SECTION code_clib
        PUBLIC    joystick
	PUBLIC	_joystick
	EXTERN	get_psg
	EXTERN	joystick_inkey


.joystick
._joystick
	;__FASTCALL__ : joystick no. in HL
        ld      a,l
	ld	hl,0
        dec     a
	jp	nz,joystick_inkey

; 0 = #define MOVE_RIGHT 1
; 1 = #define MOVE_LEFT  2
; 2 = #define MOVE_DOWN  4
; 3 = #define MOVE_UP    8
; 4 = #define MOVE_FIRE  16
; 5 = #define MOVE_FIRE2 32

got_it:
	in	a,($2b)
	cpl
	rra		;UP
	rl	l
	rra		;DOWN
	rl	l	
	rra		;LEFT
	rl	l
	rra		;RIGHT
	rl	l
	rra
	jr	nc,not_fire1
	set	4,l
not_fire1:
	in	a,($27)
	bit	5,a
	ret	nz
	set	5,l
	ret

