
        SECTION code_fp_mbfs

        PUBLIC  cos
        EXTERN  ___mbfs_setup_single
        EXTERN  ___mbfs_COS
        EXTERN  ___mbfs_return
	EXTERN	msbios

cos:
	call	___mbfs_setup_single
	ld	ix,___mbfs_COS
	call	msbios
	jp	___mbfs_return
