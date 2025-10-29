
; uint16_t in_stick_kempston(void)

SECTION code_clib
SECTION code_input

PUBLIC in_stick_kempston

EXTERN asm_in_stick_kempston

defc in_stick_kempston = asm_in_stick_kempston
