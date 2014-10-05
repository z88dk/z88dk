
; uint16_t in_mouse_amx_wheel(void)

SECTION seg_code_input

PUBLIC _in_mouse_amx_wheel

defc _in_mouse_amx_wheel = asm_in_mouse_amx_wheel

INCLUDE "input/zx/z80/asm_in_mouse_amx_wheel.asm"
