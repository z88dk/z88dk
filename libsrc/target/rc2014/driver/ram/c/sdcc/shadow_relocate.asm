
; void shadow_relocate(void * address)

SECTION smc_lib

PUBLIC _shadow_relocate

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN asm_shadow_relocate

._shadow_relocate
   pop bc
   pop hl

   push hl
   push bc

   call asm_push_di

   call asm_shadow_relocate
   jp asm_pop_ei_jp
