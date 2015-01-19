; void sp1_PrintAtInv(uchar row, uchar col, uchar colour, uint tile)
; CALLER linkage for function pointers

PUBLIC sp1_PrintAtInv

EXTERN sp1_PrintAtInv_callee
EXTERN ASMDISP_SP1_PRINTATINV_CALLEE

.sp1_PrintAtInv

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld a,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   jp sp1_PrintAtInv_callee + ASMDISP_SP1_PRINTATINV_CALLEE
