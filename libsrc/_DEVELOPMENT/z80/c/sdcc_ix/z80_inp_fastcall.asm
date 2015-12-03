
; uint8_t z80_inp(uint16_t port)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_inp_fastcall

EXTERN asm_z80_inp

defc _z80_inp_fastcall = asm_z80_inp 
