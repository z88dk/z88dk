
; void *shadowwrite(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_driver

PUBLIC shadowwrite_callee

EXTERN asm_shadowwrite

shadowwrite_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

   xor a    ; set up write to shadow ram

   jp asm_shadowwrite

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadowwrite_callee
defc _shadowwrite_callee = shadowwrite_callee
ENDIF

