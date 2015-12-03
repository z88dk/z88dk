; void sp1_MoveSprPix(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uint x, uint y)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_MoveSprPix_callee, l0_sp1_MoveSprPix_callee

EXTERN asm_sp1_MoveSprPix

_sp1_MoveSprPix_callee:

   pop af
   pop ix
   exx
   pop bc
   exx
   pop hl
   pop de
   pop bc
   push af
   
   exx
   push bc
   exx

l0_sp1_MoveSprPix_callee:

   ex (sp),iy
   
   call asm_sp1_MoveSprPix
   
   pop iy
   ret
