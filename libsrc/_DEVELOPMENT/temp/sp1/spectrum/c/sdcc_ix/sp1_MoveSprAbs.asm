; void sp1_MoveSprAbs(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uchar row, uchar col, uchar vrot, uchar hrot)

PUBLIC _sp1_MoveSprAbs

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
   ex (sp),ix
   
   call asm_sp1_MoveSprAbs
   
   pop ix
   ret

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_MoveSprAbs.asm"
