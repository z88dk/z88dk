; void *z180_otdmr(void *src, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z180

PUBLIC _z180_otdmr

EXTERN asm_z180_otdmr

_z180_otdmr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_z180_otdmr
