; void __CALLEE__ *sp1_PreShiftSpr_callee(uchar flag, uchar height, uchar width, void *srcframe, void *destframe, uchar rshift)
; 05.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_PreShiftSpr_callee

sp1_PreShiftSpr_callee:

   pop af
   pop bc
   pop iy
   pop de
   pop hl
   ld b,l
   pop hl
   pop ix
   push af
   ld a,ixl
   ld h,a
   ld a,c

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_PreShiftSpr.asm"
