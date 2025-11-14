
; void insertion_sort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC __insertion_sort_

EXTERN l0__insertion_sort__callee

__insertion_sort_:

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop bc
   
   push bc
   push de
   push hl
   push bc
   push af
   
   jp l0__insertion_sort__callee
