
; void *z180_otdr(void *src, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z180

PUBLIC z180_otdr_callee

EXTERN asm_z180_otdr

z180_otdr_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl

   ld b,e
   jp asm_z180_otdr
