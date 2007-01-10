; CALLER linkage for function pointers

XLIB l_bsearch
LIB l_bsearch_callee
XREF ASMDISP_L_BSEARCH_CALLEE

.l_bsearch

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
