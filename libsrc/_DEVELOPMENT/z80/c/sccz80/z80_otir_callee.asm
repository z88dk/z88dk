
; void *z80_otir(void *src, uint16_t port)

SECTION code_z80

PUBLIC z80_otir_callee

z80_otir_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "z80/z80/asm_z80_otir.asm"
