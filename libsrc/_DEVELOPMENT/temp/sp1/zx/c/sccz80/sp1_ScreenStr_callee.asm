; uint __CALLEE__ sp1_ScreenStr_callee(uchar row, uchar col)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_ScreenStr_callee

EXTERN asm_sp1_ScreenStr

sp1_ScreenStr_callee:

   pop hl
   pop de
   ex (sp),hl
   ld d,l

   jp asm_sp1_ScreenStr
