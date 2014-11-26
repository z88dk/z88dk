
; void shellsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION seg_code_stdlib

PUBLIC _shellsort__callee

_shellsort__callee:

   pop af
   pop ix
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "stdlib/z80/sort/asm_shellsort.asm"
