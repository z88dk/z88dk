
; void insertion_sort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_stdlib

PUBLIC __insertion_sort_

__insertion_sort_:

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
   
   call asm_insertion_sort
   
   pop ix
   ret
   
   INCLUDE "stdlib/z80/sort/insertion_sort.asm"
