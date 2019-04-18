
        SECTION code_fp_mbfs

        PUBLIC  fabs
        EXTERN  ___mbfs_setup_fabsgle
        EXTERN  ___mbfs_ABS
        EXTERN  ___mbfs_return
	EXTERN	msbios

fabs:
	call	___mbfs_setup_fabsgle
	ld	ix,___mbfs_ABS
	call	msbios
	jp	___mbfs_return
