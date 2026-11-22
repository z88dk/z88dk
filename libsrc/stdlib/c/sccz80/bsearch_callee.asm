
; void *bsearch(const void *key, const void *base,
;               size_t nmemb, size_t size,
;               int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC bsearch_callee

EXTERN asm_bsearch

bsearch_callee:

   ; Park ret, then compar/size/nmemb in the alt set. Base and key
   ; stay on the main set so the later exx can load IX.
   exx
   pop hl
   exx
   pop de
   pop bc
   pop hl
   exx
   pop bc
   pop af

   push hl
   push ix
   push bc
   exx
   push de
   pop ix
   ld de,bc
   pop bc

   call asm_bsearch
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bsearch_callee
defc _bsearch_callee = bsearch_callee
ENDIF

