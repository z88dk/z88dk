
; void shellsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC _shellsort__callee

EXTERN asm_shellsort

_shellsort__callee:

   pop af
   pop ix
   pop de
   pop hl
   pop bc
   push af
   
   jp asm_shellsort
