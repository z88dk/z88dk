
; void *shadowwrite_callee(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_driver

PUBLIC _shadowwrite_callee

EXTERN asm_shadowwrite

_shadowwrite_callee:

   pop af
   pop de
   pop hl
   pop bc
   push af

   xor a    ; set up write to shadow ram

   jp asm_shadowwrite
