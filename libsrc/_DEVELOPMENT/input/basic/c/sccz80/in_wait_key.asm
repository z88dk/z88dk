
; void in_wait_key(void)

SECTION code_clib
SECTION code_input

PUBLIC in_wait_key

EXTERN asm_in_wait_key

defc in_wait_key = asm_in_wait_key
