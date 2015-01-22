
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_stdlib

PUBLIC __quicksort_

__quicksort_:

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
   
   call asm_quicksort
   
   pop ix
   ret

   INCLUDE "stdlib/z80/sort/asm_quicksort.asm"
