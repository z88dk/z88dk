; void sp1_MoveSprPix(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uint x, uint y)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_MoveSprPix

EXTERN l0_sp1_MoveSprPix_callee

_sp1_MoveSprPix:

   pop af
   pop ix
   exx
   pop bc
   exx
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push bc
   push hl
   push af
   
   push bc
   jp l0_sp1_MoveSprPix_callee
