
; void insertion_sort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC _insertion_sort__callee

EXTERN asm_insertion_sort

_insertion_sort__callee:

   pop af
   pop ix
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_insertion_sort
