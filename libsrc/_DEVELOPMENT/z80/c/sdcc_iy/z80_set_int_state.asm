
; void z80_set_int_state(uint state)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_set_int_state

EXTERN asm_z80_set_int_state

_z80_set_int_state:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_z80_set_int_state
