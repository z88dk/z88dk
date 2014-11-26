
; void shellsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION seg_code_stdlib

PUBLIC __shellsort_

__shellsort_:

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
   
   INCLUDE "stdlib/z80/sort/asm_shellsort.asm"
