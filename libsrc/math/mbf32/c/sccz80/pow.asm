
        SECTION code_fp_mbfs

        PUBLIC  pow
        EXTERN  ___mbfs_setup_two
        EXTERN  ___mbfs_POW
        EXTERN  ___mbfs_return
	EXTERN	msbios

pow:
	call	___mbfs_setup_two
	ld	ix,___mbfs_POW
	call	msbios
	jp	___mbfs_return
