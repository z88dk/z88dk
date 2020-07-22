

	SECTION code_fp_dai32

	PUBLIC  modf
	EXTERN  ___dai32_xload
	EXTERN  ___dai32_xsave
	EXTERN  ___dai32_xfint
	EXTERN  ___dai32_xfrac
	EXTERN  ___dai32_return
    EXTERN  ___dai32_tempval

; double modf(double value, double *iptr)
modf:
    ld      hl,4
    add     hl,sp
    call    ___dai32_xload
    call    ___dai32_xfint
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    call    ___dai32_xsave

    ; And now do the fractional part
    ld      hl,4
    add     hl,sp
    call    ___dai32_xload
    call    ___dai32_xfrac
    jp      ___dai32_return




