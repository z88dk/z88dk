; void __CALLEE__ sp1_MoveSprRel_callee(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, char rel_row, char rel_col, char rel_vrot, char rel_hrot)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION seg_code_sp1

PUBLIC sp1_MoveSprRel_callee

sp1_MoveSprRel_callee:

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
   push af

   INCLUDE "temp/sp1/zx/sprites/asm_sp1_MoveSprRel.asm"
