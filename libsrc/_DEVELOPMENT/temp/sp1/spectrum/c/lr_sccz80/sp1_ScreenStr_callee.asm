; uint __CALLEE__ sp1_ScreenStr_callee(uchar row, uchar col)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XDEF sp1_ScreenStr_callee

sp1_ScreenStr_callee:

   pop hl
   pop de
   ex (sp),hl
   ld d,l

   INCLUDE "temp/sp1/spectrum/tiles/asm_sp1_ScreenStr.asm"
