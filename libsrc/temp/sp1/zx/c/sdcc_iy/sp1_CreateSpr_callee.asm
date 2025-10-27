; struct sp1_ss *sp1_CreateSpr(void *drawf, uchar type, uchar height, int graphic, uchar plane)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_CreateSpr_callee, l0_sp1_CreateSpr_callee

EXTERN asm_sp1_CreateSpr

_sp1_CreateSpr_callee:

   exx
   pop bc
   exx

   pop de
   pop bc
   ld b,c
   pop hl
   ld c,l
   pop hl
   ex (sp),hl
   ld a,c
   ld c,l
   pop hl
   
   exx
   push bc
   exx

l0_sp1_CreateSpr_callee:

   push iy
   
   call asm_sp1_CreateSpr
   
   pop iy
   ret
