; void sp1_MoveSprAbs(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uchar row, uchar col, uchar vrot, uchar hrot)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_MoveSprAbs_callee, l0_sp1_MoveSprAbs_callee

EXTERN asm_sp1_MoveSprAbs

_sp1_MoveSprAbs_callee:

   exx
   pop bc
   pop ix
   pop de
   exx
   pop hl
   pop bc
   pop de
   ld d,c
   pop bc
   ld a,c
   pop bc
   ld b,c
   ld c,a
   exx
   push bc
   push de
   exx

l0_sp1_MoveSprAbs_callee:

   ex (sp),iy
   
   call asm_sp1_MoveSprAbs
   
   pop iy
   ret
