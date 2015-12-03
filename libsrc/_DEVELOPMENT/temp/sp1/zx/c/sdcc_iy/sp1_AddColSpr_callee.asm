; uint sp1_AddColSpr(struct sp1_ss *s, void *drawf, uchar type, int graphic, uchar plane)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_AddColSpr_callee, l0_sp1_AddColSpr_callee

EXTERN asm_sp1_AddColSpr

_sp1_AddColSpr_callee:

   exx
   pop bc
   exx
   pop ix
   pop de
   pop hl
   pop bc
   ld a,l
   pop hl
   ld h,l
   ld l,a

l0_sp1_AddColSpr_callee:

   exx
   push bc
   exx

   push iy
      
   call asm_sp1_AddColSpr
   
   pop iy
   ret
