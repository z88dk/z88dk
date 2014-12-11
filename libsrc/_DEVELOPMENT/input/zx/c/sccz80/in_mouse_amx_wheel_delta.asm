
; int16_t in_mouse_amx_wheel_delta(void)

SECTION code_input

PUBLIC in_mouse_amx_wheel_delta

defc in_mouse_amx_wheel_delta = asm_in_mouse_amx_wheel_delta

INCLUDE "input/zx/z80/asm_in_mouse_amx_wheel_delta.asm"
