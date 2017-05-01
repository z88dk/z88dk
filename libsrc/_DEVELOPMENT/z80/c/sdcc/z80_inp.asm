
; uint8_t z80_inp(uint16_t port)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_inp

EXTERN asm_z80_inp

_z80_inp:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_z80_inp
