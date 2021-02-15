
; void *shadowwrite(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_driver

PUBLIC _shadowwrite

EXTERN asm_cpu_push_di
EXTERN asm_cpu_pop_ei

EXTERN asm_shadowcopy

_shadowwrite:

   pop af
   pop de
   pop hl
   pop bc

   push bc
   push hl
   push de
   push af

   call asm_cpu_push_di
   
   xor a    ; set up write to shadow ram

   call asm_shadowcopy
   jp asm_cpu_pop_ei
