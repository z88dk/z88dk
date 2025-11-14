
; void sp1_DeleteSpr_fastcall(struct sp1_ss *s)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_DeleteSpr_fastcall

EXTERN asm_sp1_DeleteSpr

defc _sp1_DeleteSpr_fastcall = asm_sp1_DeleteSpr
