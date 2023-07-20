
; void z80_outp(uint16_t port, uint8_t data)

SECTION code_clib
SECTION code_z80

PUBLIC z80_outp

EXTERN asm_z80_outp

z80_outp:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   out (c),l
   ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _z80_outp
defc _z80_outp = z80_outp
ENDIF

