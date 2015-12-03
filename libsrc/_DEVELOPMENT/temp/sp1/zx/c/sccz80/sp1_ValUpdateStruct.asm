
; sp1_ValUpdateStruct
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_ValUpdateStruct

EXTERN asm_sp1_ValUpdateStruct

defc sp1_ValUpdateStruct = asm_sp1_ValUpdateStruct
