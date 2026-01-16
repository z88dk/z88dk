
; void *z180_indr(void *dst, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_indr

EXTERN asm_z180_indr

_z180_indr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_z180_indr
