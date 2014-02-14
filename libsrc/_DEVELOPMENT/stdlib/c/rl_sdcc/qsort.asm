
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

XDEF qsort

qsort:

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
   
   push ix
   
   exx
   ld ixl,c
   ld ixh,b
   exx
   
   call asm_qsort
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_qsort.asm"
