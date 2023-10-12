

        SECTION code_fp_dai32

        PUBLIC  ___dai32_setup_single_reg
        EXTERN  ___dai32_fpac


; Used for the routines which accept single_reg precision
;
; Entry: dehl = float value
___dai32_setup_single_reg:
        ld      a, h
        ld      h, l
        ld      l, a
        ld      (___dai32_fpac+2), hl
        ex      de, hl
        ld      a, h
        ld      h, l
        ld      l, a
        ld      (___dai32_fpac+0), hl
        ret
