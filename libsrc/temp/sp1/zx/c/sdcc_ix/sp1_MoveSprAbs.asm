; void sp1_MoveSprAbs(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uchar row, uchar col, uchar vrot, uchar hrot)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_MoveSprAbs

EXTERN l0_sp1_MoveSprAbs_callee

_sp1_MoveSprAbs:

   ld hl,2
   add hl,sp
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   push de
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   push de
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   push de
   ld d,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   inc hl
   ld c,(hl)
   inc hl
   inc hl
   ld b,(hl)
   
   pop hl
   pop iy

   jp l0_sp1_MoveSprAbs_callee
