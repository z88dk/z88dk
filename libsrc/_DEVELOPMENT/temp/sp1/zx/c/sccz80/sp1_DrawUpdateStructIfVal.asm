
; sp1_DrawUpdateStructIfVal(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_DrawUpdateStructIfVal

EXTERN asm_sp1_DrawUpdateStructIfVal

sp1_DrawUpdateStructIfVal:

   push ix
   call asm_sp1_DrawUpdateStructIfVal
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_DrawUpdateStructIfVal
defc _sp1_DrawUpdateStructIfVal = sp1_DrawUpdateStructIfVal
ENDIF

