
; void *z80_indr(void *dst, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z80

PUBLIC z80_indr

EXTERN asm_z80_indr

z80_indr:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af

   ld b,e
   jp asm_z80_indr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _z80_indr
defc _z80_indr = z80_indr
ENDIF

