
; void z80_delay_ms(uint ms)

SECTION seg_code_z80

PUBLIC z80_delay_ms

z80_delay_ms:

   INCLUDE "z80/z80/asm_z80_delay_ms.asm"
