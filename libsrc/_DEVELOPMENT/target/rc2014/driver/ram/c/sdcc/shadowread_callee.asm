
; void *shadowread_callee(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_driver

PUBLIC _shadowread_callee

EXTERN asm_shadowread

_shadowread_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af

   ld a,1   ; set up read from shadow ram

   jp asm_shadowread
