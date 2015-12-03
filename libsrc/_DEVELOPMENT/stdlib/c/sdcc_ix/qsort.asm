
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC _qsort

EXTERN l0_qsort_callee

_qsort:

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

   jp l0_qsort_callee
