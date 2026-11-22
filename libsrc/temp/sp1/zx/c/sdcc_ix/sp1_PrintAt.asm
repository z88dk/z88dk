; void sp1_PrintAt(uchar row, uchar col, uchar colour, uint tile)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_PrintAt

EXTERN asm_sp1_PrintAt

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

   jp asm_sp1_PrintAt
