
; void *z80_otir(void *src, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z80

PUBLIC z80_otir_callee

EXTERN asm_z80_otir

z80_otir_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl

   ld b,e
   jp asm_z80_otir
