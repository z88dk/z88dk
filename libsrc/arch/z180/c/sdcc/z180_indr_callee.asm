
; void *z180_indr_callee(void *dst, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_indr_callee

EXTERN asm_z180_indr

_z180_indr_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_z180_indr
