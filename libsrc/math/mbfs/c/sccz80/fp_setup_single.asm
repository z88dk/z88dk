

	SECTION		code_fp_mbfs

	PUBLIC		fp_setup_single
	EXTERN		FPREG


; Put the two arguments into the required places
;
; Used for the routines which accept single precision
;
; Entry: dehl = operand
fp_setup_single:
	ld	hl,FPREG		;Store the right hand
	ld	(hl),l
	inc	hl
	ld	(hl),h
	inc	hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
	ret
