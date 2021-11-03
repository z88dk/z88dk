
; void *shadow_write(void * restrict s1, const void * restrict s2, size_t n) __smallc __z88dk_callee

SECTION smc_lib

PUBLIC shadow_write_callee

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN asm_shadow_copy

.shadow_write_callee

   pop af
   pop bc
   pop hl
   pop de
   push af

   call asm_push_di

   ld a,b
   or c         ; also set up write to shadow ram

   call NZ,asm_shadow_copy
   jp asm_pop_ei_jp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadow_write_callee
defc _shadow_write_callee = shadow_write_callee
ENDIF

