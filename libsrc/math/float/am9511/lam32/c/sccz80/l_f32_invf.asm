
SECTION code_clib
SECTION code_fp_am9511

PUBLIC  l_f32_invf

EXTERN  asm_am9511_finv_fastcall

defc l_f32_invf = asm_am9511_finv_fastcall

