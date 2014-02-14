
; void *bsearch(const void *key, const void *base,
;               size_t nmemb, size_t size,
;               int (*compar)(const void *, const void *))

XLIB bsearch

LIB asm_bsearch

bsearch:

   pop af
   pop ix
   pop de
   pop hl
   pop bc
   exx
   pop bc
   
   push bc
   exx
   push bc
   push hl
   push de
   push ix
   push af
   
   exx
   push bc
   exx
   pop af
   
   jp asm_bsearch
