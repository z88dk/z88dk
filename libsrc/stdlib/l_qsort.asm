; CALLER linkage for function pointers

SECTION code_clib
PUBLIC l_qsort
PUBLIC _l_qsort
EXTERN asm_l_qsort

.l_qsort
._l_qsort

   pop de
   pop iy
   pop hl
   pop bc
   push bc
   push hl
   push hl
   push de
   
   jp asm_l_qsort