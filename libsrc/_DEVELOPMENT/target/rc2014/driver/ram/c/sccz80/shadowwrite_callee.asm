
; void *shadowwrite(void * restrict s1, const void * restrict s2, size_t n)

SECTION smc_lib

PUBLIC shadowwrite_callee

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN asm_shadowcopy

.shadowwrite_callee

   pop af
   pop bc
   pop hl
   pop de
   push af

   call asm_push_di

   ld a,b
   or c         ; also set up write to shadow ram

   call NZ,asm_shadowcopy
   jp asm_pop_ei_jp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadowwrite_callee
defc _shadowwrite_callee = shadowwrite_callee
ENDIF

