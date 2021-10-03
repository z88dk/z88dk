

		SECTION	bss_fp
		PUBLIC	fp_seed

fp_seed:	defs	6

		SECTION	code_crt_init
IF __CPU_GBZ80__
	ld	hl,fp_seed
	ld	a,$80
	ld	(hl+),a
	ld	(hl),a
ELSE
		ld	hl,$8080
		ld	(fp_seed),hl
ENDIF
