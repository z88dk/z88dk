; void __CALLEE__ *sp1_TileEntry_callee(uchar c, void *def)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

PUBLIC sp1_TileEntry_callee

sp1_TileEntry_callee:

   pop hl
   pop de
   pop bc
   push hl

   INCLUDE "temp/sp1/zx/tiles/asm_sp1_TileEntry.asm"
