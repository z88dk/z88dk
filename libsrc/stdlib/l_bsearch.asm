; CALLER linkage for function pointers

SECTION code_clib
PUBLIC l_bsearch
PUBLIC _l_bsearch
EXTERN asm_l_bsearch

.l_bsearch
._l_bsearch

   pop af
   pop iy
   pop hl
   pop de
   pop bc
   push bc
   push de
   push hl
   push hl
   push af
   
   jp asm_l_bsearch
