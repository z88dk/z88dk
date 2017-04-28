
; void z180_outp(uint16_t port, uint8_t data)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_outp

EXTERN asm_z180_outp

_z180_outp:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_z180_outp
