
; uint16_t in_pause(uint16_t dur_ms)

SECTION code_clib
SECTION code_input

PUBLIC in_pause

EXTERN asm_in_pause

defc in_pause = asm_in_pause
