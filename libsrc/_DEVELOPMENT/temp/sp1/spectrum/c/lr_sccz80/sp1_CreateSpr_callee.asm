; struct sp1_ss __CALLEE__ *sp1_CreateSpr_callee(void *drawf, uchar type, uchar height, int graphic, uchar plane)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XDEF sp1_CreateSpr_callee

sp1_CreateSpr_callee:

   pop ix
   pop bc
   pop hl
   pop de
   ld a,e
   pop de
   ld b,e
   pop de
   push ix

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_CreateSpr.asm"
