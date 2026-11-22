
; uint16_t in_stick_cursor(void)

SECTION code_clib
SECTION code_input

PUBLIC _in_stick_cursor

EXTERN asm_in_stick_cursor

defc _in_stick_cursor = asm_in_stick_cursor
