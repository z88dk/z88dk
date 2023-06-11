

		SECTION	bss_fp
		PUBLIC	fa

		EXTERN	init_floatpack

fa:		defs	6


		SECTION code_crt_init
		call	init_floatpack
