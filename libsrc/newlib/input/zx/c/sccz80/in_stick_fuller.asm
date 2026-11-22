
; uint16_t in_stick_fuller(void)

SECTION code_clib
SECTION code_input

PUBLIC in_stick_fuller

EXTERN asm_in_stick_fuller

defc in_stick_fuller = asm_in_stick_fuller
