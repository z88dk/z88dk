; void __CALLEE__ sp1_MoveSprAbs_callee(struct sp1_ss *s, struct sp1_Rect *clip, uchar *frame, uchar row, uchar col, uchar vrot, uchar hrot)
; 04.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XDEF sp1_MoveSprAbs_callee

sp1_MoveSprAbs_callee:

   pop af
   pop de
   pop bc
   ld b,e
   pop de
   pop hl
   ld d,l
   pop hl
   pop iy
   pop ix
   push af

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_MoveSprAbs.asm"
