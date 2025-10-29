
; void shellsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC __shellsort_

EXTERN l0__shellsort__callee

__shellsort_:

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

   jp l0__shellsort__callee
