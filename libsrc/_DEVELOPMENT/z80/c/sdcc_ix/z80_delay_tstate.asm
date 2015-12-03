
; void z80_delay_tstate(uint tstates)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_delay_tstate

EXTERN asm_z80_delay_tstate

_z80_delay_tstate:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_z80_delay_tstate
