; uchar__CALLEE__ sp1_ScreenAttr_callee(uchar row, uchar col)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION seg_code_sp1

PUBLIC sp1_ScreenAttr_callee

sp1_ScreenAttr_callee:

   pop hl
   pop de
   ex (sp),hl
   ld d,l

   INCLUDE "temp/sp1/zx/tiles/asm_sp1_ScreenAttr.asm"
