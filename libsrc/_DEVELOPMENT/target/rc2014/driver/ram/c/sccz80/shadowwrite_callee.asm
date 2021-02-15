
; void *shadowwrite(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_driver

PUBLIC shadowwrite_callee

EXTERN asm_cpu_push_di
EXTERN asm_cpu_pop_ei

EXTERN asm_shadowcopy

shadowwrite_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af

   call asm_cpu_push_di

   xor a    ; set up write to shadow ram

   call asm_shadowcopy
   jp asm_cpu_pop_ei

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadowwrite_callee
defc _shadowwrite_callee = shadowwrite_callee
ENDIF

