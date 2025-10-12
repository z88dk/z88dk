; void *z180_otimr(void *src, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z180

PUBLIC z180_otimr_callee

EXTERN asm_z180_otimr

z180_otimr_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl

   ld b,e
   jp asm_z180_otimr
