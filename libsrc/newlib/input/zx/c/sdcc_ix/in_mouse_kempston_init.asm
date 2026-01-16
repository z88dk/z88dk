
; void in_mouse_kempston_init(void)

SECTION code_clib
SECTION code_input

PUBLIC _in_mouse_kempston_init

EXTERN asm_in_mouse_kempston_init

defc _in_mouse_kempston_init = asm_in_mouse_kempston_init
