
; uint16_t in_stick_int(void)

SECTION code_clib
SECTION code_input

PUBLIC _in_stick_int

EXTERN asm_in_stick_int

defc _in_stick_int = asm_in_stick_int
