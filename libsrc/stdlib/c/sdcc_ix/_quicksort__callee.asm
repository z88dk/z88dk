
; void qsort_callee(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC __quicksort__callee, l0__quicksort__callee

EXTERN asm_quicksort

__quicksort__callee:

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop bc
   push af

l0__quicksort__callee:

   push bc
   exx
   
   ex (sp),ix
   
   call asm_quicksort
   
   pop ix
   ret
