; CALLER linkage for function pointers

PUBLIC l_bsearch
PUBLIC _l_bsearch
EXTERN l_bsearch_callee
EXTERN ASMDISP_L_BSEARCH_CALLEE

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
   
   jp l_bsearch_callee + ASMDISP_L_BSEARCH_CALLEE
