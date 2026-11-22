
; sp1_DrawUpdateStructAlways(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_DrawUpdateStructAlways

EXTERN asm_sp1_DrawUpdateStructAlways

sp1_DrawUpdateStructAlways:

   push ix
   call asm_sp1_DrawUpdateStructAlways
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_DrawUpdateStructAlways
defc _sp1_DrawUpdateStructAlways = sp1_DrawUpdateStructAlways
ENDIF

