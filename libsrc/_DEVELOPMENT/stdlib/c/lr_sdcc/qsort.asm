
; void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

XDEF qsort

qsort:

   pop af
   exx
   pop bc
   exx
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   exx
   push bc
   exx
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
