
; void shadow_relocate(void * address) __z88dk_fastcall

SECTION smc_lib

PUBLIC _shadow_relocate_fastcall

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN asm_shadow_relocate

._shadow_relocate_fastcall
   call asm_push_di

   call asm_shadow_relocate
   jp asm_pop_ei_jp
