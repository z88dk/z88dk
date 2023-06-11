
; void *z80_otdr(void *src, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z80

PUBLIC z80_otdr

EXTERN asm_z80_otdr

z80_otdr:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af

   ld b,e
   jp asm_z80_otdr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _z80_otdr
defc _z80_otdr = z80_otdr
ENDIF

