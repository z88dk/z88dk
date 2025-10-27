
; void  __FASTCALL__ sp1_RemoveCharStruct(struct sp1_cs *cs)
; 05.2007 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_RemoveCharStruct

EXTERN asm_sp1_RemoveCharStruct

sp1_RemoveCharStruct:

   push ix
   call asm_sp1_RemoveCharStruct
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_RemoveCharStruct
defc _sp1_RemoveCharStruct = sp1_RemoveCharStruct
ENDIF

