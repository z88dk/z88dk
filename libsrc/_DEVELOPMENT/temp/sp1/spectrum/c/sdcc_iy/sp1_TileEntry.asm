; void *sp1_TileEntry(uchar c, void *def)

XDEF _sp1_TileEntry

_sp1_TileEntry:

   ld hl,2
   add hl,sp
   
   ld c,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)

   INCLUDE "temp/sp1/spectrum/tiles/asm_sp1_TileEntry.asm"
