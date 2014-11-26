; void *sp1_TileEntry(uchar c, void *def)

SECTION seg_code_sp1

PUBLIC _sp1_TileEntry

_sp1_TileEntry:

   ld hl,2
   add hl,sp
   
   ld c,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)

   INCLUDE "temp/sp1/zx/tiles/asm_sp1_TileEntry.asm"
