

	SECTION		code_fp_mbfs

	PUBLIC		___mbfs_setup_single_reg
	EXTERN		___mbfs_FPREG
	EXTERN		___mbfs_VALTYP


; Used for the routines which accept single_reg precision
;
; Entry: -
; Stack: defw return address
;        defw callee return address
;        defw left hand LSW
;        defw left hand MSW
___mbfs_setup_single_reg:
	ld	a,4
	ld	(___mbfs_VALTYP),a
        ld      (___mbfs_FPREG + 0),hl
        ld      (___mbfs_FPREG + 2),de
	pop	hl
	push	ix
	push	hl
	ret
