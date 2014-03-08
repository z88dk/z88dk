
; void z80_delay_ms(uint ms)

XDEF z80_delay_ms

z80_delay_ms:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_z80_delay_ms.asm"
