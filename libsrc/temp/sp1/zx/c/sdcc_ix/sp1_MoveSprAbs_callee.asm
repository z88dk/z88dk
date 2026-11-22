; void sp1_MoveSprAbs(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uchar row, uchar col, uchar vrot, uchar hrot)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_MoveSprAbs_callee, l0_sp1_MoveSprAbs_callee

EXTERN asm_sp1_MoveSprAbs

_sp1_MoveSprAbs_callee:

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

l0_sp1_MoveSprAbs_callee:

   ex (sp),ix
   
   call asm_sp1_MoveSprAbs
   
   pop ix
   ret
