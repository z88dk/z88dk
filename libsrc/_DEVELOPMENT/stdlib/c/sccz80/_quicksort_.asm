
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION seg_code_stdlib

PUBLIC _quicksort_

EXTERN asm_quicksort

_quicksort_:

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
   
   jp asm_quicksort
