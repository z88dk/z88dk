
; void shadow_relocate(void * address) __smallc __z88dk_fastcall

SECTION smc_lib

PUBLIC shadow_relocate

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN asm_shadow_relocate

.shadow_relocate
   call asm_push_di

   call asm_shadow_relocate
   jp asm_pop_ei_jp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadow_relocate
defc _shadow_relocate = shadow_relocate
ENDIF

