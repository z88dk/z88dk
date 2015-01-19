; void sp1_GetTiles(struct sp1_Rect *r, struct sp1_tp *dest)
; CALLER linkage for function pointers

PUBLIC sp1_GetTiles

EXTERN sp1_GetTiles_callee
EXTERN ASMDISP_SP1_GETTILES_CALLEE

.sp1_GetTiles

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   push de
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   pop hl
   jp sp1_GetTiles_callee + ASMDISP_SP1_GETTILES_CALLEE
