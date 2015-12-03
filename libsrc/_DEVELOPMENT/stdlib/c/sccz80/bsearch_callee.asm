
; void *bsearch(const void *key, const void *base,
;               size_t nmemb, size_t size,
;               int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC bsearch_callee

EXTERN asm_bsearch

bsearch_callee:

   pop af
   pop ix
   pop de
   pop hl
   pop bc
   exx
   pop bc
   push af
   
   push bc
   pop af
   exx
   
   jp asm_bsearch
