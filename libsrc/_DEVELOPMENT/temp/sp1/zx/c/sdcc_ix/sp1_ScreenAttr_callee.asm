; uchar sp1_ScreenAttr(uchar row, uchar col)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_ScreenAttr_callee

EXTERN asm_sp1_ScreenAttr

_sp1_ScreenAttr_callee:

   pop af
   pop hl
   pop de
   push af
   
   ld d,l
   jp asm_sp1_ScreenAttr
