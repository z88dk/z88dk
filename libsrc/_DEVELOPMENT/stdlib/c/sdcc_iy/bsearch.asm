
; void *bsearch(const void *key, const void *base,
;               size_t nmemb, size_t size,
;               int (*compar)(const void *, const void *))

SECTION code_stdlib

PUBLIC _bsearch

_bsearch:

   pop af
   exx
   pop bc
   exx
   pop bc
   pop hl
   pop de
   pop ix
   
   push ix
   push de
   push hl
   push bc
   exx
   push bc
   exx
   push af
   
   exx
   push bc
   exx
   pop af

   INCLUDE "stdlib/z80/asm_bsearch.asm"
