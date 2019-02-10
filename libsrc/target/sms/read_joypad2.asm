	SECTION	code_clib	
	PUBLIC	read_joypad2
	PUBLIC	_read_joypad2
	
;==============================================================
; int read_joypad2()
;==============================================================
; Reads the joystick 2
;==============================================================
.read_joypad2
._read_joypad2
	in	a, ($dc)	; Reads UP and DOWN
	cpl			; Inverts all bits
	rla
	rla
	rla			; Puts them into the 2 lower bits
	and	$03		; Masks them
	ld	l, a
	in	a, ($dd)	; Reads the remaining bits
	cpl			; Inverts all bits
	add	a
	add	a		; Shifts them to the correct position
	or	l		; Groups them with the first two
	ld	h, 0
	ld	l, a		; Puts the result in HL
	ret
