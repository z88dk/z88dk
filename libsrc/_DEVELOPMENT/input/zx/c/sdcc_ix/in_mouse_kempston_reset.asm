
; void in_mouse_kempston_reset(void)

SECTION seg_code_input

PUBLIC _in_mouse_kempston_reset

EXTERN asm_in_mouse_kempston_reset

defc _in_mouse_kempston_reset = asm_in_mouse_kempston_reset
