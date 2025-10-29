
; void z80_outp_callee(uint16_t port, uint8_t data)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_outp_callee

EXTERN asm_z80_outp

_z80_outp_callee:

   pop af
   pop bc
   dec sp
   pop hl
   push af
   out (c),h
   ret
