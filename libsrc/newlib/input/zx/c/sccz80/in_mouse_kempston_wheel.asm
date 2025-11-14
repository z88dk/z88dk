
; uint16_t in_mouse_kempston_wheel(void)

SECTION code_clib
SECTION code_input

PUBLIC in_mouse_kempston_wheel

EXTERN asm_in_mouse_kempston_wheel

defc in_mouse_kempston_wheel = asm_in_mouse_kempston_wheel
