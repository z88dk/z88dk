
; void *z80_otir(void *src, uint16_t port)

SECTION code_clib
SECTION code_z80

PUBLIC z80_otir_callee

EXTERN asm_z80_otir

z80_otir_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_z80_otir
