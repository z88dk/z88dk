; void sp1_PrintAtInv(uchar row, uchar col, uint tile)
; CALLER linkage for function pointers

XLIB sp1_PrintAtInv

LIB sp1_PrintAtInv_callee
XREF ASMDISP_SP1_PRINTATINV_CALLEE

.sp1_PrintAtInv

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   jp sp1_PrintAtInv_callee + ASMDISP_SP1_PRINTATINV_CALLEE
