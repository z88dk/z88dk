
; void *bsearch(const void *key, const void *base,
;               size_t nmemb, size_t size,
;               int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC _bsearch

EXTERN l0_bsearch_callee

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
   push de
   push hl
   push bc
   push bc
   push af

   jp l0_bsearch_callee
