
; void *bsearch(const void *key, const void *base,
;               size_t nmemb, size_t size,
;               int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC bsearch

EXTERN asm_bsearch

bsearch:

   push ix

   ld hl,sp+4
   ld e,(hl+)
   ld d,(hl)
   push de
   pop ix

   ld hl,sp+6
   ld e,(hl+)
   ld d,(hl)

   ld hl,sp+8
   ld c,(hl+)
   ld b,(hl)
   push bc

   ld hl,sp+12
   ld c,(hl+)
   ld b,(hl)
   push bc

   ld hl,sp+16
   ld c,(hl+)
   ld b,(hl)
   push bc
   pop af
   pop bc
   pop hl

   call asm_bsearch
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bsearch
defc _bsearch = bsearch
ENDIF

