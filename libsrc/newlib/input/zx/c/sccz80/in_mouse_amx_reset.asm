
; void in_mouse_amx_reset(void)

SECTION code_clib
SECTION code_input

PUBLIC in_mouse_amx_reset

EXTERN asm_in_mouse_amx_reset

defc in_mouse_amx_reset = asm_in_mouse_amx_reset
