
	SECTION	code_l_sdcc

	PUBLIC	__moduint
	GLOBAL	l_divu16


__moduint:
	ld	hl,sp+5

        ld      d,(hl)
        dec     hl
        ld      e,(hl)
        dec     hl
        ld      b,(hl)
        dec     hl
        ld      c,(hl)

        call    l_divu16

        ;; Already in DE

        ret
