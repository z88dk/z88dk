; void sp1_MoveSprPix(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uint x, uint y)

PUBLIC _sp1_MoveSprPix

_sp1_MoveSprPix:

   pop af
   exx
   pop ix
   pop bc
   exx
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   exx
   push bc
   push ix
   push af
   
   push iy

   ld iyl,c
   ld iyh,b
   
   call asm_sp1_MoveSprPix
   
   pop iy
   ret

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_MoveSprPix.asm"
