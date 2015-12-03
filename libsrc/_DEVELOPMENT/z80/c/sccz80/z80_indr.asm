
; void *z80_indr(void *dst, uint16_t port)

SECTION code_clib
SECTION code_z80

PUBLIC z80_indr

EXTERN asm_z80_indr

z80_indr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_z80_indr
