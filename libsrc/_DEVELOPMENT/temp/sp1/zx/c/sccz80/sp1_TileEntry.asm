; void *sp1_TileEntry(uchar c, void *def)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_TileEntry

EXTERN asm_sp1_TileEntry

sp1_TileEntry:

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   
   jp asm_sp1_TileEntry
