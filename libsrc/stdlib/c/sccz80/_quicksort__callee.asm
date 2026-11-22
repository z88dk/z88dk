
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC _quicksort__callee

EXTERN asm_quicksort

_quicksort__callee:

   pop hl
   pop de
   pop bc
   pop af
   ex (sp),hl

   push ix
   push de
   pop ix

   ld de,bc
   ld bc,hl
   push af
   pop hl

   call asm_quicksort
   pop ix
   ret
