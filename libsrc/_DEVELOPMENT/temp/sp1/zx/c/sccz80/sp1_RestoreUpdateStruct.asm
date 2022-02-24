
; sp1_RestoreUpdateStruct
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_RestoreUpdateStruct

EXTERN asm_sp1_RestoreUpdateStruct

defc sp1_RestoreUpdateStruct = asm_sp1_RestoreUpdateStruct

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_RestoreUpdateStruct
defc _sp1_RestoreUpdateStruct = sp1_RestoreUpdateStruct
ENDIF

