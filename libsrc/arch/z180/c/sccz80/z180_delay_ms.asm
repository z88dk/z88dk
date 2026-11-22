
; void z180_delay_ms(uint ms)

SECTION code_clib
SECTION code_z180

PUBLIC z180_delay_ms

EXTERN asm_z180_delay_ms

defc z180_delay_ms = asm_z180_delay_ms
