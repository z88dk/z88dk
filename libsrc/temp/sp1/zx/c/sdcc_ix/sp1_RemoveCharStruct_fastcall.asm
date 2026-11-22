
; void  sp1_RemoveCharStruct_fastcall(struct sp1_cs *cs)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_RemoveCharStruct_fastcall

EXTERN asm_sp1_RemoveCharStruct

defc _sp1_RemoveCharStruct_fastcall = asm_sp1_RemoveCharStruct
