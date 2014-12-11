; void sp1_MoveSprRel(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, char rel_row, char rel_col, char rel_vrot, char rel_hrot)

SECTION code_temp_sp1

PUBLIC _sp1_MoveSprRel

_sp1_MoveSprRel:

   exx
   pop bc
   pop de
   pop iy
   exx
   pop hl
   pop de
   ld d,e
   pop bc
   ld e,c
   pop bc
   ld a,c
   pop bc
   ld b,c
   ld c,a
   
   push bc
   push bc
   push bc
   push de
   push hl
   exx
   push iy
   push de
   push bc
   
   push ix
   
   ld ixl,e
   ld ixh,d
   
   exx
   
   call asm_sp1_MoveSprRel
   
   pop ix
   ret

   INCLUDE "temp/sp1/zx/sprites/asm_sp1_MoveSprRel.asm"
