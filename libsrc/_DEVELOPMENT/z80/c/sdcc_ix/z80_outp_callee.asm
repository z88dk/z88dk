
; void z80_outp_callee(uint16_t port, uint8_t data)

SECTION code_z80

PUBLIC _z80_outp_callee

_z80_outp_callee:

   pop af
   pop bc
   pop hl
   push af
   
   INCLUDE "z80/z80/asm_z80_outp.asm"
