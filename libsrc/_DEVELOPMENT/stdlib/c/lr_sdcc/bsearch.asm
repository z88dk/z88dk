
; void *bsearch(const void *key, const void *base,
;               size_t nmemb, size_t size,
;               int (*compar)(const void *, const void *))

XDEF bsearch

bsearch:

   pop af
   exx
   pop bc
   exx
   pop de
   pop hl
   pop bc
   exx
   pop de
   
   push de
   exx
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
   push de
   pop af
   exx

   call asm_bsearch
   
   pop ix
   ret
   
   INCLUDE "stdlib/z80/asm_bsearch.asm"
