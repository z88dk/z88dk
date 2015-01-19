; void sp1_ClearRectInv(struct sp1_Rect *r, uchar tile, uchar rflag)
; CALLER linkage for function pointers

PUBLIC sp1_ClearRectInv

EXTERN sp1_ClearRectInv_callee
EXTERN ASMDISP_SP1_CLEARRECTINV_CALLEE

.sp1_ClearRectInv

   ld hl,2
   add hl,sp
   ld a,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   inc hl
   ld c,(hl)
   inc hl
   ld h,(hl)
   ld l,c
   push de
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   pop hl
   jp sp1_ClearRectInv_callee + ASMDISP_SP1_CLEARRECTINV_CALLEE
