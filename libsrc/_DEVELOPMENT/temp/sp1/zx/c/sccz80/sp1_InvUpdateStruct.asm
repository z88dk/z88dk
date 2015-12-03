
; sp1_InvUpdateStruct
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_InvUpdateStruct

EXTERN asm_sp1_InvUpdateStruct

defc sp1_InvUpdateStruct = asm_sp1_InvUpdateStruct
