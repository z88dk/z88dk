
; void qsort_callee(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC _qsort_callee, l0_qsort_callee

EXTERN asm_qsort

_qsort_callee:

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop bc
   push af
   
l0_qsort_callee:

   push bc
   exx
   
   ex (sp),ix
   
   call asm_qsort
   
   pop ix
   ret
