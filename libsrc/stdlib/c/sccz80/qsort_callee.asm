
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC qsort_callee

EXTERN asm_qsort

qsort_callee:

   pop af
   pop ix
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_qsort
