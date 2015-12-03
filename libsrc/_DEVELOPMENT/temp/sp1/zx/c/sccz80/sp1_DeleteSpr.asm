
; void __FASTCALL__ sp1_DeleteSpr(struct sp1_ss *s)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_DeleteSpr

EXTERN asm_sp1_DeleteSpr

defc sp1_DeleteSpr = asm_sp1_DeleteSpr
