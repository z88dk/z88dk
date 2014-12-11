
; void *z80_inir(void *dst, uint16_t port)

SECTION code_z80

PUBLIC z80_inir_callee

z80_inir_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "z80/z80/asm_z80_inir.asm"
