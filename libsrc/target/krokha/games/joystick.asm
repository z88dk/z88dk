
	SECTION code_clib

	PUBLIC	joystick
	PUBLIC	_joystick


; Krokha: Bit 0 = fire/start 1
;        Bit 1 = up 
;        Bit 2 = down
;        Bit 3 = right
;        Bit 4 = left 

; z88dk:
; #define MOVE_RIGHT 1
; #define MOVE_LEFT  2
; #define MOVE_DOWN  4
; #define MOVE_UP    8
; #define MOVE_FIRE  16

joystick:
_joystick:
	ld	a,($f7ff)
	cpl
	ld	b,a
	rra
	and	31
	ld	l,a
	ld	h,0
	ld	de,joystick_table
	add	hl,de
	ld	l,(hl)
	ld	h,0
	; Consider fire
	ld	a,b
	rla
	rla
	rla
	rla
	and	@00010000
	or	l
	ld	l,a
	ret

	SECTION data_clib

joystick_table:
	defb	@0000	;Nothing pressed
	defb	@1000	;UP
	defb	@0100	;DOWN
	defb	@1100	;UP + DOWN
	defb	@0001	;RIGHT
	defb	@1001	;RIGHT + UP
	defb	@0101	;RIGHT + DOWN
	defb	@1101	;RIGHT + UP + DOWN
	defb	@0010	;LEFT
	defb	@1010	;LEFT + UP
	defb	@0110	;LEFT + DOWN
	defb	@1110	;LEFT + UP +DOWN
	defb	@0011	;LEFT + RIGHT
	defb	@1011	;LEFT + RIGHT + UP	
	defb	@0111	;LEFT + RIGHT + DOWN
	defb	@1111	;LEFT + RIGHT + UP + DOWN

