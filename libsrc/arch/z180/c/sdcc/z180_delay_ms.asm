
; void z180_delay_ms(uint ms)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_delay_ms

EXTERN asm_z180_delay_ms

_z180_delay_ms:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_z180_delay_ms
