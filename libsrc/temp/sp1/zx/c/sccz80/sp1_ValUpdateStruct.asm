
; sp1_ValUpdateStruct
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_ValUpdateStruct

EXTERN asm_sp1_ValUpdateStruct

sp1_ValUpdateStruct:

   push ix
   call asm_sp1_ValUpdateStruct
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_ValUpdateStruct
defc _sp1_ValUpdateStruct = sp1_ValUpdateStruct
ENDIF

