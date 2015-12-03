
; void insertion_sort_callee(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC __insertion_sort__callee

EXTERN asm_insertion_sort

__insertion_sort__callee:

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   push af
   
   jp asm_insertion_sort
