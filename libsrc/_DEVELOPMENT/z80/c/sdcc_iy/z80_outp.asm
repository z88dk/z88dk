
; void z80_outp(uint16_t port, uint8_t data)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_outp

EXTERN asm_z80_outp

_z80_outp:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_z80_outp
