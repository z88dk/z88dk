
; void *shadowwrite(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_driver

PUBLIC _shadowwrite

EXTERN asm_shadowwrite

_shadowwrite:

   pop af
   pop de
   pop hl
   pop bc

   push bc
   push hl
   push de
   push af

   xor a    ; set up write to shadow ram

   jp asm_shadowwrite
