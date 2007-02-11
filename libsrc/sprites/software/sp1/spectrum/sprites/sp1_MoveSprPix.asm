; void sp1_MoveSprPix(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uint x, uint y)
; CALLER linkage for function pointers

XLIB sp1_MoveSprPix

LIB sp1_MoveSprPix_callee
XREF ASMDISP_SP1_MOVESPRPIX_CALLEE

.sp1_MoveSprPix

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

   jp sp1_MoveSprPix_callee + ASMDISP_SP1_MOVESPRPIX_CALLEE
