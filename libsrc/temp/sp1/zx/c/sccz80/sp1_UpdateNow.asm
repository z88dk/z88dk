
; sp1_UpdateNow
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_UpdateNow

EXTERN asm_sp1_UpdateNow

sp1_UpdateNow:

   push ix
   call asm_sp1_UpdateNow
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_UpdateNow
defc _sp1_UpdateNow = sp1_UpdateNow
ENDIF

