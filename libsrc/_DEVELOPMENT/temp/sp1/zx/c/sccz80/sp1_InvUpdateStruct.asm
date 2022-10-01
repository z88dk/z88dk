
; sp1_InvUpdateStruct
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_InvUpdateStruct

EXTERN asm_sp1_InvUpdateStruct

sp1_InvUpdateStruct:

   push ix
   call asm_sp1_InvUpdateStruct
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_InvUpdateStruct
defc _sp1_InvUpdateStruct = sp1_InvUpdateStruct
ENDIF

