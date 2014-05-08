
; void bit_click(void)

PUBLIC _bit_click

_bit_click:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "sound/bit/z80/asm_bit_click.asm"
