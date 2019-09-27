

	MODULE	display_variables


	SECTION	bss_driver

	GLOBAL	fg_colour
	GLOBAL	bg_colour
	GLOBAL	tx
	GLOBAL	ty

        ;; Foreground drawing colour
fg_colour:
        defs    1
        ;; Background drawing colour
bg_colour:
        defs    1


tx:
        defs    1
ty:
        defs    1
