
; void *z80_otdr(void *src, uint16_t port)

SECTION code_clib
SECTION code_z80

PUBLIC z80_otdr

EXTERN asm_z80_otdr

z80_otdr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_z80_otdr
