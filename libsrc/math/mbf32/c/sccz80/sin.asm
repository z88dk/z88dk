
        SECTION code_fp_mbfs

        PUBLIC  sin
        EXTERN  ___mbfs_setup_single
        EXTERN  ___mbfs_SIN
        EXTERN  ___mbfs_return
	EXTERN	msbios

sin:
	call	___mbfs_setup_single
	ld	ix,___mbfs_SIN
	call	msbios
	jp	___mbfs_return
