
; void z180_outp(uint16_t port, uint8_t data)

SECTION code_clib
SECTION code_z180

PUBLIC z180_outp_callee

EXTERN asm_z180_outp

z180_outp_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_z180_outp
