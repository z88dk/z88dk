; uchar__CALLEE__ sp1_ScreenAttr_callee(uchar row, uchar col)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XDEF sp1_ScreenAttr_callee

sp1_ScreenAttr_callee:

   pop hl
   pop de
   ex (sp),hl
   ld d,l

   INCLUDE "temp/sp1/spectrum/tiles/asm_sp1_ScreenAttr.asm"
