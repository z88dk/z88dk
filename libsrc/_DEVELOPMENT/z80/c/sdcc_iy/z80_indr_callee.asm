
; void *z80_indr_callee(void *dst, uint16_t port)

SECTION code_z80

PUBLIC _z80_indr_callee

_z80_indr_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "z80/z80/asm_z80_indr.asm"
