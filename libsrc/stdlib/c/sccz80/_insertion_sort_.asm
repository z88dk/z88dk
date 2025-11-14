
; void insertion_sort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC _insertion_sort_

EXTERN asm_insertion_sort

_insertion_sort_:

   pop af
   pop ix
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push hl
   push af
   
   jp asm_insertion_sort
