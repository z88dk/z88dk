
; void *shadow_read(void * restrict s1, const void * restrict s2, size_t n) __smallc

SECTION smc_lib

PUBLIC shadow_read

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN asm_shadow_copy

.shadow_read
   pop af
   pop bc
   pop hl
   pop de

   push de
   push hl
   push bc
   push af

   call asm_push_di

   ld a,b
   or c

   scf          ; set up read from shadow ram

   call NZ,asm_shadow_copy
   jp asm_pop_ei_jp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadow_read
defc _shadow_read = shadow_read
ENDIF

