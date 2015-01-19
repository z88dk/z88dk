; void sp1_PrintAt(uchar row, uchar col, uchar colour, uint tile)
; CALLER linkage for function pointers

PUBLIC sp1_PrintAt

EXTERN sp1_PrintAt_callee
EXTERN ASMDISP_SP1_PRINTAT_CALLEE

.sp1_PrintAt

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld a,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   jp sp1_PrintAt_callee + ASMDISP_SP1_PRINTAT_CALLEE
