; void *sp1_TileEntry(uchar c, void *def)
; CALLER linkage for function pointers

XLIB sp1_TileEntry

LIB asm_sp1_TileEntry

sp1_TileEntry:

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   
   jp asm_sp1_TileEntry
