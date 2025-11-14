
; uint16_t in_stick_fuller(void)

SECTION code_clib
SECTION code_input

PUBLIC _in_stick_fuller

EXTERN asm_in_stick_fuller

defc _in_stick_fuller = asm_in_stick_fuller
