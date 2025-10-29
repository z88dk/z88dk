
; uint8_t z180_inp(uint16_t port)

SECTION code_clib
SECTION code_z180

PUBLIC z180_inp

EXTERN asm_z180_inp

defc z180_inp = asm_z180_inp
