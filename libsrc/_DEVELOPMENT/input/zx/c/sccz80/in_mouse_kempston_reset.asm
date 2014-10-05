
; void in_mouse_kempston_reset(void)

SECTION seg_code_input

PUBLIC in_mouse_kempston_reset

EXTERN asm_in_mouse_kempston_reset

defc in_mouse_kempston_reset = asm_in_mouse_kempston_reset
