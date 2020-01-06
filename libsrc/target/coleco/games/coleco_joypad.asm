;
; Joystick handling for the Colecovision
;
;

		MODULE	coleco_joypad
		SECTION	code_clib
		PUBLIC	coleco_joypad

; Ports 0xfc and 0xff
;
; Bit 0 - up
; Bit 1 - Right
; Bit 2 - Down
; Bit 3 - Left
; Bit 6 = Fire 0
;
; Other buttons can be found out from the keypad ports
;
;
; Writing to port 0x80 keypad = true
; Writing to port 0xc0 keypad = false
;
; If keypad is false then reading joystick on ports
;

; Output
; 0 = #define MOVE_RIGHT 1
; 1 = #define MOVE_LEFT  2
; 2 = #define MOVE_DOWN  4
; 3 = #define MOVE_UP    8
; 4 = #define MOVE_FIRE  16
; 5 = #define MOVE_FIRE2 32


; hl = 1 - player 1 joystick
;    = 2 - player 2 joystick
;    = 3 - player 1 keypad
;    = 4 - player 2 keypad

coleco_joypad:
	ld	h,l
	ld	a,1		;And read the joystick
	out	($c0),a	
	bit	0,h
	ld	bc,0xff		;J2
	jr	z,read_sticks
	ld	c,0xfc
read_sticks:
	in	a,(c)
	ld	l,0
	bit	0,a
	jr	nz,not_up
	set	3,l
not_up:
	bit	1,a
	jr	nz,not_right
	set	0,l
not_right:
	bit	2,a
	jr	nz,not_down
	set	2,l
not_down:
	bit	3,a
	jr	nz,not_left
	set	1,l
not_left:
	bit	6,a
	jr	nz,not_fire2
	set	5,l
not_fire2:
	; Now read the keypad port
	ld	a,1
	out	($80),a		;And read the keypad
	in	a,(c)		;Keypad values
	bit	6,a
	jr	nz,not_fire
	set	4,l
not_fire:
	; l = parsed out joystick
	; h = joystick number
	; a = keypad value
	ld	b,a
	ld	a,h
	ld	h,0
	cp	3
	jr	z,read_keypad
	cp	4
	ret	nz
read_keypad:
	ld	a,b
	and	15
	ex	de,hl
	ld	c,a
	ld	b,0
	ld	hl,button_mapping
	add	hl,bc
	ld	a,(hl)
	ex	de,hl
	ld	h,a		; l = joypad, h = keypad values
	ret


	SECTION	rodata_clib

button_mapping:
	defb	0		;0	nothing pressed
	defb	'8'		;1	Button 8
	defb	'4'		;2	Button 4
	defb	'5'		;3	Button 5
	defb	'C'		;4	Button F4
	defb	'7'		;5	Button 7
	defb	'#'		;6	Button #
	defb	'2'		;7	Button 2
	defb	'D'		;8	Button F3
	defb	'*'		;9	Button *
	defb	'0'		;a	Button 0
	defb	'9'		;b	Button 9
	defb	'3'		;c	Button 3
	defb	'1'		;d	Button 1
	defb	'6'		;e	Button 6
	defb	0		;f	Nothing pressed
