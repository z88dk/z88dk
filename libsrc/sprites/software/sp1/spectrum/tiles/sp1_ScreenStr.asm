; uint sp1_ScreenStr(uchar row, uchar col)
; CALLER linkage for function pointers

XLIB sp1_ScreenStr

LIB sp1_ScreenStr_callee
XREF ASMDISP_SP1_SCREENSTR_CALLEE

.sp1_ScreenStr

   ld hl,2
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   jp sp1_ScreenStr_callee + ASMDISP_SP1_SCREENSTR_CALLEE
