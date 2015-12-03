
; void *bsearch_callee(const void *key, const void *base,
;               size_t nmemb, size_t size,
;               int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC _bsearch_callee, l0_bsearch_callee

EXTERN asm_bsearch

_bsearch_callee:

   pop af
   exx
   pop bc
   exx
   pop bc
   pop hl
   pop de
   pop ix
   push af

l0__bsearch_callee:

   exx
   push bc
   exx
   pop af

   jp asm_bsearch
