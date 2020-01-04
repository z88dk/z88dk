
	SECTION	code_clib
	PUBLIC	generic_console_xypos

	EXTERN	__console_w

	defc	DISPLAY = 0xf000


generic_console_xypos:
        ld      hl,DISPLAY
        ld      de,(__console_w)
        ld      d,0
        and     a
        sbc     hl,de
        inc     b
generic_console_printc_1:
        add     hl,de
        djnz    generic_console_printc_1
generic_console_printc_3:
        add     hl,bc                   ;hl now points to address in display
        ret
