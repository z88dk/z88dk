; void *sp1_TileEntry(uchar c, void *def)
; CALLER linkage for function pointers

XLIB sp1_TileEntry

LIB sp1_TileEntry_callee
XREF ASMDISP_SP1_TILEENTRY_CALLEE

.sp1_TileEntry

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   jp sp1_TileEntry_callee + ASMDISP_SP1_TILEENTRY_CALLEE
