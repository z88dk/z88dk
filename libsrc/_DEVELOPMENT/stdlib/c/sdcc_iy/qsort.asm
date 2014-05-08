
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

PUBLIC _qsort

_qsort:

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   
   push ix
   push de
   push hl
   push bc
   push af
   
   INCLUDE "stdlib/z80/asm_qsort.asm"
