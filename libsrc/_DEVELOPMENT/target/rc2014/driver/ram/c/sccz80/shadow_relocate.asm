
; void shadow_relocate(void * address) __smallc

SECTION smc_lib

PUBLIC shadow_relocate

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN asm_shadow_relocate

.shadow_relocate
   pop bc
   pop hl

   push hl
   push bc

   call asm_push_di

   call asm_shadow_relocate
   jp asm_pop_ei_jp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadow_relocate
defc _shadow_relocate = shadow_relocate
ENDIF

