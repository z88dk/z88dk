
; void *z180_inir(void *dst, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_inir

EXTERN asm_z180_inir

_z180_inir:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_z180_inir
