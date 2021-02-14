
; void *shadowread(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_driver

PUBLIC shadowread_callee

EXTERN asm_shadowread

shadowread_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

   ld a,1   ; set up read from shadow ram

   jp asm_shadowread

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadowread_callee
defc _shadowread_callee = shadowread_callee
ENDIF

