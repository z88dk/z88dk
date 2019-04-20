
        SECTION code_fp_mbfs

        PUBLIC  tan
        EXTERN  ___mbfs_setup_single
        EXTERN  ___mbfs_TAN
        EXTERN  ___mbfs_return
	EXTERN	msbios

tan:
	call	___mbfs_setup_single
	ld	ix,___mbfs_TAN
	call	msbios
	jp	___mbfs_return
