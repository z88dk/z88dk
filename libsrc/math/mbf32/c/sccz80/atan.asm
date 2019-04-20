
        SECTION code_fp_mbfs

        PUBLIC  atan
        EXTERN  ___mbfs_setup_single
        EXTERN  ___mbfs_ATN
        EXTERN  ___mbfs_return
	EXTERN	msbios

atan:
	call	___mbfs_setup_single
	ld	ix,___mbfs_ATN
	call	msbios
	jp	___mbfs_return
