

SECTION code_fp_math32

PUBLIC  cm32_sdcc___fseq_callee

EXTERN cm32_sdcc_fsreadr_callee
EXTERN m32_compare_callee

; Entry: stack: float right, float left, ret
cm32_sdcc___fseq_callee:
    call    cm32_sdcc_fsreadr_callee    ;Exit dehl = right
    call    m32_compare_callee
    scf
    ret     z
    ccf
    dec     hl
    ret
