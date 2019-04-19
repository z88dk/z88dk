
        SECTION code_fp_mbfs

        PUBLIC  log10
        EXTERN  ___mbfs_setup_single
        EXTERN  ___mbfs_LOG
        EXTERN  ___mbfs_DVBCDE
        EXTERN  ___mbfs_FPREG
        EXTERN  ___mbfs_return
	EXTERN	msbios

log10:
	call	___mbfs_setup_single
	ld	ix,___mbfs_LOG
	call	msbios
	ld	de,(___mbfs_FPREG)
	ld	bc,(___mbfs_FPREG + 2)
	ld	hl,0x5d8e		;ln(10)
	ld	(___mbfs_FPREG),hl
	ld	hl,0x8213
	ld	(___mbfs_FPREG + 2),hl
	ld	ix,___mbfs_DVBCDE
	call	msbios
	jp	___mbfs_return
