; void sp1_MoveSprPix(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uint x, uint y)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_MoveSprPix_callee, l0_sp1_MoveSprPix_callee

EXTERN asm_sp1_MoveSprPix

_sp1_MoveSprPix_callee:

   exx
   pop de
   pop bc
   exx
   
   pop iy
   pop hl
   pop de
   pop bc
   
   exx
   push de
   push bc
   exx

l0_sp1_MoveSprPix_callee:

   ex (sp),ix
   
   call asm_sp1_MoveSprPix
   
   pop ix
   ret
