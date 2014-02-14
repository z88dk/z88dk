
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

XDEF qsort_callee

qsort_callee:

   pop af
   pop ix
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "../../z80/asm_qsort.asm"
