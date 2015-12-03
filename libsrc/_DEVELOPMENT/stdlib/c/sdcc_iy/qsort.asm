
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC _qsort

EXTERN asm_qsort

_qsort:

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   
   push hl
   push de
   push hl
   push bc
   push af
   
   jp asm_qsort
