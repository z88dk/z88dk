; void *z180_otimr(void *src, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z180

PUBLIC z180_otimr

EXTERN asm_z180_otimr

z180_otimr:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af

   ld b,e
   jp asm_z180_otimr
