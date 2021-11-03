
; void *shadow_read(void * restrict s1, const void * restrict s2, size_t n) __smallc __z88dk_callee

SECTION smc_lib

PUBLIC shadow_read_callee

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN asm_shadow_copy

.shadow_read_callee
   pop af
   pop bc
   pop hl
   pop de
   push af

   call asm_push_di

   ld a,b
   or c

   scf          ; set up read from shadow ram

   call NZ,asm_shadow_copy
   jp asm_pop_ei_jp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadow_read_callee
defc _shadow_read_callee = shadow_read_callee
ENDIF

