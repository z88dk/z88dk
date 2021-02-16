
; void *shadowread(void * restrict s1, const void * restrict s2, size_t n)

SECTION smc_lib

PUBLIC shadowread_callee

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN asm_shadowcopy

.shadowread_callee

   pop af
   pop bc
   pop hl
   pop de
   push af

   call asm_push_di

   ld a,b
   or c

   ld a,$01     ; set up read from shadow ram

   call NZ,asm_shadowcopy
   jp asm_pop_ei_jp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadowread_callee
defc _shadowread_callee = shadowread_callee
ENDIF

