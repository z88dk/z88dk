

        SECTION code_fp_dai32
        PUBLIC  ___dai32_return
        EXTERN  ___dai32_fpac

; Return the value that's in the FP registers
___dai32_return:
        ld      hl, (___dai32_fpac+0)
        ld      a, h
        ld      h, l
        ld      l, a
        ex      de, hl
        ld      hl, (___dai32_fpac+2)
        ld      a, h
        ld      h, l
        ld      l, a
        ret
