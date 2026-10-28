
; void shellsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *))

SECTION code_clib
SECTION code_stdlib

PUBLIC _shellsort_

EXTERN asm_shellsort

_shellsort_:

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
   pop hl

   call asm_shellsort
   pop ix
   ret
