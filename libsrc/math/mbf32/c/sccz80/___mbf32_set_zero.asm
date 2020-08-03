
        SECTION         code_fp_mbf32

        PUBLIC          ___mbf32_set_zero
        EXTERN          ___mbf32_FPREG

___mbf32_set_zero:
IF __CPU_GBZ80__
    ld      hl,___mbf32_FPREG
    xor     a
    ld      (hl+),a
    ld      (hl+),a
    ld      (hl+),a
    ld      (hl),a
ELSE
    ld      hl,0
    ld      (___mbf32_FPREG),hl
    ld      (___mbf32_FPREG+2),hl
ENDIF
    ret
