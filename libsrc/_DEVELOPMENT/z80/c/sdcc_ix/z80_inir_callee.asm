
; void *z80_inir_callee(void *dst, uint16_t port)

SECTION code_z80

PUBLIC _z80_inir_callee

_z80_inir_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "z80/z80/asm_z80_inir.asm"
