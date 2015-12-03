; void sp1_ClearRectInv(struct sp1_Rect *r, uchar colour, uchar tile, uchar rflag)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_ClearRectInv

EXTERN asm_sp1_ClearRectInv

sp1_ClearRectInv:

   ld hl,2
   add hl,sp
   ld a,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   inc hl
   inc hl
   ld c,(hl)
   inc hl
   ld h,(hl)
   ld l,c
   push de
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   pop hl
   
   jp asm_sp1_ClearRectInv
