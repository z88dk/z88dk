
; uint16_t in_stick_2(void)

SECTION code_clib
SECTION code_input

PUBLIC in_stick_2

EXTERN asm_in_stick_2

defc in_stick_2 = asm_in_stick_2
