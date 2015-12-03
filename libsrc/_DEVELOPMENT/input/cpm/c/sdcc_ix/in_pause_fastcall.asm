
; uint16_t in_pause_fastcall(uint16_t dur_ms)

SECTION code_clib
SECTION code_input

PUBLIC _in_pause_fastcall

EXTERN asm_in_pause

defc _in_pause_fastcall = asm_in_pause
