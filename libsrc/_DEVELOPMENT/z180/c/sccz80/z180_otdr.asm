
; void *z180_otdr(void *src, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z180

PUBLIC z180_otdr

EXTERN asm_z180_otdr

z180_otdr:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af

   ld b,e
   jp asm_z180_otdr
