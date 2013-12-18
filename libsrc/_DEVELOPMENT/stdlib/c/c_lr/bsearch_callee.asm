
XDEF bsearch_callee

bsearch_callee:

   pop hl
   pop ix
   pop de
   pop af
   pop bc
   ex (sp),hl
   
   push hl
   push af
   pop hl
   pop af

INCLUDE "../../z80/asm_bsearch.asm"
