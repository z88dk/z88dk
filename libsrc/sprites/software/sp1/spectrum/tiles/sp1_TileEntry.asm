; void *sp1_TileEntry(uchar c, void *def)
; CALLER linkage for function pointers

PUBLIC sp1_TileEntry

EXTERN sp1_TileEntry_callee
EXTERN ASMDISP_SP1_TILEENTRY_CALLEE

.sp1_TileEntry

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   jp sp1_TileEntry_callee + ASMDISP_SP1_TILEENTRY_CALLEE
