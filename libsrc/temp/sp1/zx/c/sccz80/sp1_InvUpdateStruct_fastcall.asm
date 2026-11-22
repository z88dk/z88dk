
; sp1_InvUpdateStruct

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_InvUpdateStruct_fastcall

EXTERN asm_sp1_InvUpdateStruct

defc _sp1_InvUpdateStruct_fastcall = asm_sp1_InvUpdateStruct
