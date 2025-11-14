
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC __quicksort_

EXTERN asm_quicksort

__quicksort_:

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

   jp asm_quicksort
