; struct sp1_ss *sp1_CreateSpr(void *drawf, uchar type, uchar height, int graphic, uchar plane)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_CreateSpr

EXTERN l0_sp1_CreateSpr_callee

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

   jp l0_sp1_CreateSpr_callee
