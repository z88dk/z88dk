
; uint16_t in_stick_sinclair1(void)

SECTION code_clib
SECTION code_input

PUBLIC _in_stick_sinclair1

EXTERN asm_in_stick_sinclair1

defc _in_stick_sinclair1 = asm_in_stick_sinclair1
