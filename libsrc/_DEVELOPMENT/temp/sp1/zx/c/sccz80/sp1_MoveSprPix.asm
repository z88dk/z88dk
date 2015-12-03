; void sp1_MoveSprPix(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uint x, uint y)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_MoveSprPix

EXTERN asm_sp1_MoveSprPix

sp1_MoveSprPix:

   pop af
   pop bc
   pop de
   pop hl
   pop iy
   pop ix
   push hl
   push hl
   push hl
   push de
   push bc
   push af

   jp asm_sp1_MoveSprPix
