

		SECTION		code_clib

		PUBLIC		asm_set_cursor_state

		INCLUDE		"mc6845.inc"

; Set the state of the hardware cursor
;
; Entry: l = cursor state:
;		0x00	= always on
;		0x20	= off
;		0x40	= fast blink
;		0x60	= slow blink
;        l = lower 5 bits = first cursor row
;        h = cursor end row
;
; Uses: af, l, bc (on some targets)
asm_set_cursor_state:
	ld	a,0x0a
IF address_w > 256
	ld	bc,address_w
	out	(c),a
ELSE
	out	(address_w),a
ENDIF
IF register_w > 256
	ld	bc,register_w
	out	(c),l
ELSE
	ld	a,l	
	out	(register_w),a
ENDIF
	ld	a,0x0b
IF address_w > 256
	ld	bc,address_w
	out	(c),a
ELSE
	out	(address_w),a
ENDIF
IF register_w > 256
	ld	bc,register_w
	out	(c),h
ELSE
	ld	a,h
	out	(register_w),a
ENDIF
	ret
