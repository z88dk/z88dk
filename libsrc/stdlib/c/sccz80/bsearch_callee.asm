
; void *bsearch(const void *key, const void *base,
;               size_t nmemb, size_t size,
;               int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC bsearch_callee

EXTERN asm_bsearch

bsearch_callee:

   ex (sp),ix
   pop hl
   pop de
   pop bc
   pop af
   ex (sp),hl

   push ix
   push de
   pop ix

   push hl
   push bc
   push af

   ld hl,sp+10
   ld e,(hl+)
   ld d,(hl)

   ld hl,sp+6
   ld c,(hl+)
   ld b,(hl)

   ld hl,sp+10
   ld (hl+),c
   ld (hl),b

   push de
   pop af
   pop hl
   pop de
   pop bc

   ex (sp),ix
   pop ix

   call asm_bsearch
   pop ix
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bsearch_callee
defc _bsearch_callee = bsearch_callee
ENDIF

