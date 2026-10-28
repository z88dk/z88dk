
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC qsort_callee

EXTERN asm_qsort

qsort_callee:

   pop hl
   pop de
   pop bc
   pop af
   ex (sp),hl

   push ix
   push de
   pop ix
   push bc
   pop de
   push hl
   push af
   pop hl
   pop bc

   call asm_qsort
   pop ix
   ret
