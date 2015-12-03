
; void *z80_otdr(void *src, uint16_t port)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_otdr

EXTERN asm_z80_otdr

_z80_otdr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_z80_otdr
