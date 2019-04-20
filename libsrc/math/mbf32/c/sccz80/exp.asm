
        SECTION code_fp_mbfs

        PUBLIC  exp
        EXTERN  ___mbfs_setup_expgle
        EXTERN  ___mbfs_EXP
        EXTERN  ___mbfs_return
	EXTERN	msbios

exp:
	call	___mbfs_setup_expgle
	ld	ix,___mbfs_EXP
	call	msbios
	jp	___mbfs_return
