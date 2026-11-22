; void sp1_MoveSprRel(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, char rel_row, char rel_col, char rel_vrot, char rel_hrot)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_MoveSprRel_callee, l0_sp1_MoveSprRel_callee

EXTERN asm_sp1_MoveSprRel

_sp1_MoveSprRel_callee:

   exx
   pop de
   pop bc
   exx
   
   pop iy
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
   
   exx
   push de
   push bc
   exx

l0_sp1_MoveSprRel_callee:
   
   ex (sp),ix
   
   call asm_sp1_MoveSprRel
   
   pop ix
   ret
