
; void *bsearch(const void *key, const void *base,
;               size_t nmemb, size_t size,
;               int (*compar)(const void *, const void *))

SECTION seg_code_stdlib

PUBLIC _bsearch

_bsearch:

   pop af
   exx
   pop bc
   exx
   pop bc
   pop hl
   pop de
   exx
   pop de
   
   push de
   exx
   push de
   push hl
   push bc
   exx
   push bc
   exx
   push af
   
   push ix
   
   exx
   ld ixl,e
   ld ixh,d
   push bc
   pop af
   exx

   call asm_bsearch
   
   pop ix
   ret

   INCLUDE "stdlib/z80/asm_bsearch.asm"
