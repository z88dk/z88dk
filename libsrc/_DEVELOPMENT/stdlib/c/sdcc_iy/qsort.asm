
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_stdlib

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
   
   jp asm_qsort
   
   INCLUDE "stdlib/z80/asm_qsort.asm"
