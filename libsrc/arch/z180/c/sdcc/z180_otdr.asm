
; void *z180_otdr(void *src, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_otdr

EXTERN asm_z180_otdr

_z180_otdr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_z180_otdr
