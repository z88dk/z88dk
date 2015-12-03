; struct sp1_ss *sp1_CreateSpr(void *drawf, uchar type, uchar height, int graphic, uchar plane)
; CALLER linkage for function pointers

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_CreateSpr

EXTERN asm_sp1_CreateSpr

sp1_CreateSpr:

   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   inc hl
   ld b,(hl)
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ex de,hl
   
   jp asm_sp1_CreateSpr
