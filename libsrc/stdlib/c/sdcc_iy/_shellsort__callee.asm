
; void shellsort_callee(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC __shellsort__callee

EXTERN asm_shellsort

__shellsort__callee:

   pop af
   pop bc
   pop hl
   pop de
   pop ix
   push af
   
   jp asm_shellsort
