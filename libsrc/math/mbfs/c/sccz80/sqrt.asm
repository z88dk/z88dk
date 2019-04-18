
        SECTION code_fp_mbfs

        PUBLIC  sqrt
        EXTERN  ___mbfs_setup_single
        EXTERN  ___mbfs_SQR
        EXTERN  ___mbfs_return
	EXTERN	msbios

sqrt:
	call	___mbfs_setup_single
	ld	ix,___mbfs_SQR
	call	msbios
	jp	___mbfs_return
