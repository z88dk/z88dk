
; void z80_delay_ms(uint ms)

SECTION code_clib
SECTION code_z80

PUBLIC z80_delay_ms

EXTERN asm_z80_delay_ms

defc z80_delay_ms = asm_z80_delay_ms
