
; void in_wait_key(void)

SECTION code_clib
SECTION code_input

PUBLIC _in_wait_key

EXTERN asm_in_wait_key

defc _in_wait_key = asm_in_wait_key
