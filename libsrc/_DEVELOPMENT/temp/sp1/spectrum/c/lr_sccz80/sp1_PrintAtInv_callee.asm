; void __CALLEE__ sp1_PrintAtInv_callee(uchar row, uchar col, uchar colour, uint tile)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_PrintAtInv_callee

sp1_PrintAtInv_callee:

   pop af
   pop bc
   pop hl
   pop de
   ld d,l
   pop hl
   push af
   ld a,d
   ld d,l

   INCLUDE "temp/sp1/spectrum/tiles/asm_sp1_PrintAtInv.asm"
