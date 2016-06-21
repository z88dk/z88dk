

		SECTION	bss_fp
		PUBLIC	fp_seed

fp_seed:	defs	6

		SECTION	code_crt_init
		ld	hl,$8080
		ld	(fp_seed),hl
