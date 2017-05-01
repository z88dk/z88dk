
; void *z180_otir(void *src, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_otir

EXTERN asm_z180_otir

_z180_otir:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_z180_otir
