

	MODULE	display_variables


	SECTION	bss_driver

	PUBLIC	__fgcolour
	PUBLIC	__bgcolour
	PUBLIC	generic_console_256font

	EXTERN	CRT_256FONT
	

        ;; Foreground drawing colour
__fgcolour:
        defs    1
        ;; Background drawing colour
__bgcolour:
        defs    1

generic_console_256font:	defw	CRT_256FONT
