
; void shellsort_callee(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_stdlib

PUBLIC __shellsort__callee

__shellsort__callee:

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   push af
   
   INCLUDE "stdlib/z80/sort/asm_shellsort.asm"
