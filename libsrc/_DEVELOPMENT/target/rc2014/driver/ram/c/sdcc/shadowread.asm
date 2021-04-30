
; void *shadowread(void * restrict s1, const void * restrict s2, size_t n)

SECTION smc_lib

PUBLIC _shadowread

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN asm_shadowcopy

._shadowread

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

   call NZ,asm_shadowcopy
   jp asm_pop_ei_jp
