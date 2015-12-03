
; sp1_RemoveUpdateStruct
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_RemoveUpdateStruct

EXTERN asm_sp1_RemoveUpdateStruct

defc sp1_RemoveUpdateStruct = asm_sp1_RemoveUpdateStruct
