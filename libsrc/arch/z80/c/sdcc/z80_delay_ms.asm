
; void z80_delay_ms(uint ms)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_delay_ms

EXTERN asm_z80_delay_ms

_z80_delay_ms:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_z80_delay_ms
