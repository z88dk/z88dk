
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC _qsort_callee

EXTERN asm_qsort

_qsort_callee:

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   push af
   
   jp asm_qsort
