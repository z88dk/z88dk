
; void *z180_inir(void *dst, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z180

PUBLIC z180_inir_callee

EXTERN asm_z180_inir

z180_inir_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl

   ld b,e
   jp asm_z180_inir
