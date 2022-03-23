
; sp1_DrawUpdateStructIfNotRem(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_DrawUpdateStructIfNotRem

EXTERN asm_sp1_DrawUpdateStructIfNotRem

sp1_DrawUpdateStructIfNotRem:

   push ix
   call asm_sp1_DrawUpdateStructIfNotRem
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_DrawUpdateStructIfNotRem
defc _sp1_DrawUpdateStructIfNotRem = sp1_DrawUpdateStructIfNotRem
ENDIF

