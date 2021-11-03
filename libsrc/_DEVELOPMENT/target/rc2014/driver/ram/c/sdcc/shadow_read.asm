
; void *shadow_read(void * restrict s1, const void * restrict s2, size_t n)

SECTION smc_lib

PUBLIC _shadow_read

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN asm_shadow_copy

._shadow_read
   pop af
   pop de
   pop hl
   pop bc

   push bc
   push hl
   push de
   push af

   call asm_push_di
   
   ld a,b
   or c

   scf          ; set up read from shadow ram

   call NZ,asm_shadow_copy
   jp asm_pop_ei_jp
