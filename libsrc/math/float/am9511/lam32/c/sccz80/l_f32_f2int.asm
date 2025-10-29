
SECTION code_clib
SECTION code_fp_am9511

PUBLIC  l_f32_f2sint
PUBLIC  l_f32_f2uint

EXTERN  asm_am9511_f2sint
EXTERN  asm_am9511_f2uint

; Convert floating point number to int
defc l_f32_f2sint = asm_am9511_f2sint
defc l_f32_f2uint = asm_am9511_f2uint

