
; void *z80_inir(void *dst, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z80

PUBLIC z80_inir

EXTERN asm_z80_inir

z80_inir:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af

   ld b,e
   jp asm_z80_inir

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _z80_inir
defc _z80_inir = z80_inir
ENDIF

