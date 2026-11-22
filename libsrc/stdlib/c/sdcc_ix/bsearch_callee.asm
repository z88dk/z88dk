
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
   exx
   pop de
   push af
   
l0_bsearch_callee:
   
   push de
   ex (sp),ix

   push bc
   pop af

   exx

   call asm_bsearch
   
   pop ix
   ret
