; uint __CALLEE__ sp1_ScreenStr_callee(uchar row, uchar col)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_temp_sp1

PUBLIC sp1_ScreenStr_callee

sp1_ScreenStr_callee:

   pop hl
   pop de
   ex (sp),hl
   ld d,l

   INCLUDE "temp/sp1/zx/tiles/asm_sp1_ScreenStr.asm"
