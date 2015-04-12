
; void z80_delay_ms_fastcall(uint ms)

SECTION code_z80

PUBLIC _z80_delay_ms_fastcall

_z80_delay_ms_fastcall:

   INCLUDE "z80/z80/asm_z80_delay_ms.asm"
