

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
;
; Uses: af, l
asm_set_cursor_state:
	ld	a,0x0a		; start_ras
	out	(address_w),a
	in	a,(register_r)
	; Read the register  0x0a
	and	@00011111
	or	l
	ld	l,a
	ld	a,0x0a
	out	(address_w),a
	ld	a,l	
	out	(register_w),a
	ret

