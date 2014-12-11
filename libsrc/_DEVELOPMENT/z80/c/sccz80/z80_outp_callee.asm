
; void z80_outp(uint16_t port, uint8_t data)

SECTION code_z80

PUBLIC z80_outp_callee

z80_outp_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "z80/z80/asm_z80_outp.asm"
