
; uint16_t in_stick_int(void)

SECTIN code_input

PUBLIC in_stick_int

EXTERN asm_in_stick_int

defc in_stick_int = asm_in_stick_int
