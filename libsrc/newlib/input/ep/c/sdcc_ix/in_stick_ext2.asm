
; uint16_t in_stick_ext2(void)

SECTION code_clib
SECTION code_input

PUBLIC _in_stick_ext2

EXTERN asm_in_stick_ext2

defc _in_stick_ext2 = asm_in_stick_ext2
