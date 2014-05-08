; struct sp1_ss *sp1_CreateSpr(void *drawf, uchar type, uchar height, int graphic, uchar plane)

PUBLIC _sp1_CreateSpr

_sp1_CreateSpr:

   ld hl,2
   add hl,sp
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld b,(hl)
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   inc hl
   push de
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   pop hl
   ex de,hl
   
   push ix
   
   call asm_sp1_CreateSpr
   
   pop ix
   ret

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_CreateSpr.asm"
