
    SECTION code_fp_am9511

    PUBLIC  l_f32_f2slong
    PUBLIC  l_f32_f2ulong

    EXTERN  asm_am9511_f2slong
    EXTERN  asm_am9511_f2ulong

; Convert floating polong number to long
defc l_f32_f2slong = asm_am9511_f2slong
defc l_f32_f2ulong = asm_am9511_f2ulong

