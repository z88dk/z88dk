
; void insertion_sort_callee(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_stdlib

PUBLIC __insertion_sort__callee

__insertion_sort__callee:

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   push af
   
   INCLUDE "stdlib/z80/sort/asm_insertion_sort.asm"
