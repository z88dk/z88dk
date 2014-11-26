
; void insertion_sort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION seg_code_stdlib

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
   push ix
   push af
   
   jp asm_insertion_sort
