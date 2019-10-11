
	SECTION	code_fp_mbf64

	PUBLIC	___mbf64_set_zero
	EXTERN	___mbf64_FA


___mbf64_set_zero:
        ld      b,8
        ld      hl,___mbf64_FA
zero_1:
        ld      (hl),0
        inc     hl
        djnz    zero_1
        ret
