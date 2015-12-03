; void sp1_PutTilesInv(struct sp1_Rect *r, struct sp1_tp *src)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_PutTilesInv

EXTERN asm_sp1_PutTilesInv

sp1_PutTilesInv:

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
   
   jp asm_sp1_PutTilesInv
