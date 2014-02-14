
; long strtol( const char * restrict nptr, char ** restrict endptr, int base)

XDEF strtol

strtol:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   INCLUDE "../../z80/asm_strtol.asm"
