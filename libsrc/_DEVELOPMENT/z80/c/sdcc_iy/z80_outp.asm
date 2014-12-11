
; void z80_outp(uint16_t port, uint8_t data)

SECTION code_z80

PUBLIC _z80_outp

_z80_outp:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "z80/z80/asm_z80_outp.asm"
