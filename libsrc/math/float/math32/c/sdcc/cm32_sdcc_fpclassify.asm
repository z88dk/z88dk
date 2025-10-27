

SECTION code_fp_math32
PUBLIC cm32_sdcc_fpclassify

EXTERN m32_fpclassify

cm32_sdcc_fpclassify:
    pop bc                      ; pop ret
    pop hl
    pop de
    push de
    push hl
    push bc                     ; push ret
    call m32_fpclassify
    ld l,a
    ld h,0
    ret
