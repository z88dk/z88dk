
; sp1_RemoveUpdateStruct
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_RemoveUpdateStruct

EXTERN asm_sp1_RemoveUpdateStruct

sp1_RemoveUpdateStruct:

   push ix
   call asm_sp1_RemoveUpdateStruct
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_RemoveUpdateStruct
defc _sp1_RemoveUpdateStruct = sp1_RemoveUpdateStruct
ENDIF

