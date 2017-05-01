
; void z180_set_int_state(uint8_t state)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_set_int_state

EXTERN asm_z180_set_int_state

_z180_set_int_state:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_z180_set_int_state
