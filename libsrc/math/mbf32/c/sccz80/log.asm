
        SECTION code_fp_mbfs

        PUBLIC  log
        EXTERN  ___mbfs_setup_single
        EXTERN  ___mbfs_LOG
        EXTERN  ___mbfs_return
	EXTERN	msbios

log:
	call	___mbfs_setup_single
	ld	ix,___mbfs_LOG
	call	msbios
	jp	___mbfs_return
