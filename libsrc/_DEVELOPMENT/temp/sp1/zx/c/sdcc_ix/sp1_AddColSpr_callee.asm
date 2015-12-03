; uint sp1_AddColSpr(struct sp1_ss *s, void *drawf, uchar type, int graphic, uchar plane)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_AddColSpr_callee, l0_sp1_AddColSpr_callee

EXTERN asm_sp1_AddColSpr

_sp1_AddColSpr_callee:

   exx
   pop bc
   pop de
   exx
   pop de
   pop hl
   pop bc
   ld a,l
   pop hl
   ld h,l
   ld l,a
   exx

l0_sp1_AddColSpr_callee:

   push bc
   push de
   exx
   
   ex (sp),ix
   
   call asm_sp1_AddColSpr
   
   pop ix
   ret
