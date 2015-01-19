; void sp1_MoveSprRel(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, char rel_row, char rel_col, char rel_vrot, char rel_hrot)
; CALLER linkage for function pointers

PUBLIC sp1_MoveSprRel

EXTERN sp1_MoveSprRel_callee
EXTERN ASMDISP_SP1_MOVESPRREL_CALLEE

.sp1_MoveSprRel

   pop af
   pop de
   pop bc
   ld b,e
   pop de
   pop hl
   ld d,l
   pop hl
   pop iy
   pop ix
   push hl
   push hl
   push hl
   push hl
   push de
   push bc
   push de
   push af
   jp sp1_MoveSprRel_callee + ASMDISP_SP1_MOVESPRREL_CALLEE
