
; sp1_ValUpdateStruct

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_ValUpdateStruct_fastcall

EXTERN asm_sp1_ValUpdateStruct

defc _sp1_ValUpdateStruct_fastcall = asm_sp1_ValUpdateStruct
