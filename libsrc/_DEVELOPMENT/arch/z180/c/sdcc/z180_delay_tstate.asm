
; void z180_delay_tstate(uint tstates)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_delay_tstate

EXTERN asm_z180_delay_tstate

_z180_delay_tstate:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_z180_delay_tstate
