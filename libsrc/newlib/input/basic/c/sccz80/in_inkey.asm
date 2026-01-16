
; int in_inkey(void)

SECTION code_clib
SECTION code_input

PUBLIC in_inkey

EXTERN asm_in_inkey

defc in_inkey = asm_in_inkey
