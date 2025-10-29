
; void in_wait_nokey(void)

SECTION code_clib
SECTION code_input

PUBLIC _in_wait_nokey

EXTERN asm_in_wait_nokey

defc _in_wait_nokey = asm_in_wait_nokey
