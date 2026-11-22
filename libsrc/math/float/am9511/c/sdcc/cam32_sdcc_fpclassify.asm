

SECTION code_fp_am9511
PUBLIC cam32_sdcc_fpclassify

EXTERN asm_am9511_fpclassify

cam32_sdcc_fpclassify:
    pop bc                      ; pop ret
    pop hl
    pop de
    push de
    push hl
    push bc                     ; push ret
    call asm_am9511_fpclassify
    ld l,a
    ld h,0
    ret
