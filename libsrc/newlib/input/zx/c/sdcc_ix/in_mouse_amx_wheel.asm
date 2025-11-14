
; uint16_t in_mouse_amx_wheel(void)

SECTION code_clib
SECTION code_input

PUBLIC _in_mouse_amx_wheel

EXTERN asm_in_mouse_amx_wheel

defc _in_mouse_amx_wheel = asm_in_mouse_amx_wheel
