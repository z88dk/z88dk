; void sp1_MoveSprRel(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, char rel_row, char rel_col, char rel_vrot, char rel_hrot)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_MoveSprRel_callee, l0_sp1_MoveSprRel_callee

EXTERN asm_sp1_MoveSprRel

_sp1_MoveSprRel_callee:

   exx
   pop bc
   pop ix
   pop de
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
   exx
   push bc

l0_sp1_MoveSprRel_callee:

   push de
   exx

   ex (sp),iy
   
   call asm_sp1_MoveSprRel
   
   pop iy
   ret
