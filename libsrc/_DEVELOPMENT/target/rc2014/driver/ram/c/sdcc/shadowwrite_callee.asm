
; void *shadowwrite_callee(void * restrict s1, const void * restrict s2, size_t n)

SECTION smc_lib

PUBLIC _shadowwrite_callee

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN asm_shadowcopy

._shadowwrite_callee

   pop af
   pop de
   pop hl
   pop bc
   push af

   call asm_push_di

   ld a,b
   or c         ; also set up write to shadow ram

   call NZ,asm_shadowcopy
   jp asm_pop_ei_jp
