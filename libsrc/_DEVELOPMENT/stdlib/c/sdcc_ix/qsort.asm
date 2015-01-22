
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_stdlib

PUBLIC _qsort

_qsort:

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop bc
   
   push bc
   exx
   push de
   push hl
   push bc
   push af
   
   exx
   push bc
   exx
   
   ex (sp),ix
   
   call asm_qsort
   
   pop ix
   ret
   
   INCLUDE "stdlib/z80/asm_qsort.asm"
