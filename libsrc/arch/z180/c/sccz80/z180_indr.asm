
; void *z180_indr(void *dst, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z180

PUBLIC z180_indr

EXTERN asm_z180_indr

z180_indr:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af

   ld b,e
   jp asm_z180_indr
