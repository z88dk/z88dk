
; void z80_delay_ms_fastcall(uint ms)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_delay_ms_fastcall

EXTERN asm_z80_delay_ms

defc _z80_delay_ms_fastcall = asm_z80_delay_ms
