
; uint16_t in_stick_ext2(void)

SECTIN code_input

PUBLIC in_stick_ext2

EXTERN asm_in_stick_ext2

defc in_stick_ext2 = asm_in_stick_ext2
