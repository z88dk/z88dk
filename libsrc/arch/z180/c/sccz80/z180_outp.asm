
; void z180_outp(uint16_t port, uint8_t data)

SECTION code_clib
SECTION code_z180

PUBLIC z180_outp

EXTERN asm_z180_outp

z180_outp:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   out (c),l
   ret
