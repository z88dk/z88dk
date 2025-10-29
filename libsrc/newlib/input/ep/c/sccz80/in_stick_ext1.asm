
; uint16_t in_stick_ext1(void)

SECTIN code_input

PUBLIC in_stick_ext1

EXTERN asm_in_stick_ext1

defc in_stick_ext1 = asm_in_stick_ext1
