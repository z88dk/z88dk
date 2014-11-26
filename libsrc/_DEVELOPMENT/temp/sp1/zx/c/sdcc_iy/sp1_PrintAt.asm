; void sp1_PrintAt(uchar row, uchar col, uchar colour, uint tile)

SECTION seg_code_sp1

PUBLIC _sp1_PrintAt

_sp1_PrintAt:

   ld hl,2
   add hl,sp
   
   ld d,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)

   INCLUDE "temp/sp1/zx/tiles/asm_sp1_PrintAt.asm"
