
		MODULE generic_console_attrs

		SECTION	code_clib
		PUBLIC	generic_console_set_ink
		PUBLIC	generic_console_set_paper
		PUBLIC	generic_console_set_inverse

		EXTERN	__zx_console_attr


generic_console_set_paper:
	rlca
	rlca
	rlca
        and     @00111000
	ld	c,a
        ld      hl,__zx_console_attr
        ld      a,(hl)
        and     @11000111
        or      c
        ld      (hl),a
generic_console_set_inverse:
	ret

generic_console_set_ink:
	and	7
	ld	c,a
        ld      hl,__zx_console_attr
        ld      a,(hl)
        and     @11111000
	or	c
        ld      (hl),a
        ret
