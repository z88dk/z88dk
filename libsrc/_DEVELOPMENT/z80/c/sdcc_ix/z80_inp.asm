
; uint8_t z80_inp(uint16_t port)

SECTION code_z80

PUBLIC _z80_inp

_z80_inp:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "z80/z80/asm_z80_inp.asm"
