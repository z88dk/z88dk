; void sp1_PrintAt(uchar row, uchar col, uint tile)
; CALLER linkage for function pointers

XLIB sp1_PrintAt

LIB sp1_PrintAt_callee
XREF ASMDISP_SP1_PRINTAT_CALLEE

.sp1_PrintAt

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   jp sp1_PrintAt_callee + ASMDISP_SP1_PRINTAT_CALLEE
