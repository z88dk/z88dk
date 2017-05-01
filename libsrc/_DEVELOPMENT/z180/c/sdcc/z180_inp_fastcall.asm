
; uint8_t z180_inp(uint16_t port)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_inp_fastcall

EXTERN asm_z180_inp

defc _z180_inp_fastcall = asm_z180_inp
