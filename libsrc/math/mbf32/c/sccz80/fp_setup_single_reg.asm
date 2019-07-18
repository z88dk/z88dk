

	SECTION		code_fp_mbf32

	PUBLIC		___mbf32_setup_single_reg
	EXTERN		___mbf32_FPREG
	EXTERN		___mbf32_VALTYP


; Used for the routines which accept single_reg precision
;
; Entry: -
; Stack: defw return address
;        defw callee return address
;        defw left hand LSW
;        defw left hand MSW
___mbf32_setup_single_reg:
	ld	a,4
	ld	(___mbf32_VALTYP),a
        ld      (___mbf32_FPREG + 0),hl
IF __CPU_8080__
	ex	de,hl
        ld      (___mbf32_FPREG + 2),hl
ELSE
        ld      (___mbf32_FPREG + 2),de
ENDIF
IF !__CPU_8080__
	pop	hl
	push	ix
	push	hl
ENDIF
	ret
