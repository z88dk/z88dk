
; void  __FASTCALL__ sp1_RemoveCharStruct(struct sp1_cs *cs)
; 05.2007 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_RemoveCharStruct

EXTERN asm_sp1_RemoveCharStruct

defc sp1_RemoveCharStruct = asm_sp1_RemoveCharStruct
