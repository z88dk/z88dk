
; int16_t in_mouse_amx_wheel_delta(void)

SECTION seg_code_input

PUBLIC _in_mouse_amx_wheel_delta

defc _in_mouse_amx_wheel_delta = asm_in_mouse_amx_wheel_delta

INCLUDE "input/zx/z80/asm_in_mouse_amx_wheel_delta.asm"
