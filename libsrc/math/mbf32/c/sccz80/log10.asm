
        SECTION code_fp_mbf32

        PUBLIC  log10
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_LOG
        EXTERN  ___mbf32_DVBCDE
        EXTERN  ___mbf32_FPREG
        EXTERN  ___mbf32_return
	EXTERN	msbios

log10:
	call	___mbf32_setup_single
IF __CPU_INTEL__
	call	___mbf32_LOG
	ld	hl,(___mbf32_FPREG)
	ex	de,hl
	ld	hl,(___mbf32_FPREG + 2)
	ld	c,l
	ld	b,h
ELSE
	ld	ix,___mbf32_LOG
	call	msbios
	ld	de,(___mbf32_FPREG)
	ld	bc,(___mbf32_FPREG + 2)
ENDIF
	ld	hl,0x5d8e		;ln(10)
	ld	(___mbf32_FPREG),hl
	ld	hl,0x8213
	ld	(___mbf32_FPREG + 2),hl
IF __CPU_INTEL__
	call	___mbf32_DVBCDE
ELSE
	ld	ix,___mbf32_DVBCDE
	call	msbios
ENDIF
	jp	___mbf32_return
