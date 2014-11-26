
; void insertion_sort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION seg_code_stdlib

PUBLIC _insertion_sort__callee

_insertion_sort__callee:

   pop af
   pop ix
   pop de
   pop hl
   pop bc
   push af
   
   INCLUDE "stdlib/z80/sort/asm_insertion_sort.asm"
