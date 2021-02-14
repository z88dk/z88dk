
; void *shadowread(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_driver

PUBLIC _shadowread

EXTERN asm_shadowread

_shadowread:

   pop af
   pop de
   pop hl
   pop bc

   push bc
   push hl
   push de
   push af

   ld a,1   ; set up read from shadow ram

   jp asm_shadowread
