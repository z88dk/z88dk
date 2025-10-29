
; void shellsort_callee(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC __shellsort__callee, l0__shellsort__callee

EXTERN asm_shellsort

__shellsort__callee:

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop bc
   push af

l0__shellsort__callee:

   push bc
   exx
   
   ex (sp),ix
   
   call asm_shellsort
   
   pop ix
   ret
