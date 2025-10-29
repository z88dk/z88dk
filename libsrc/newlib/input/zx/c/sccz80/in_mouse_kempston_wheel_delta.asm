
; int16_t in_mouse_kempston_wheel_delta(void)

SECTION code_clib
SECTION code_input

PUBLIC in_mouse_kempston_wheel_delta

EXTERN asm_in_mouse_kempston_wheel_delta

defc in_mouse_kempston_wheel_delta = asm_in_mouse_kempston_wheel_delta
