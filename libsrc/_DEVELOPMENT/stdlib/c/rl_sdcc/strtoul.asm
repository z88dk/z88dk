
; unsigned long strtoul( const char * restrict nptr, char ** restrict endptr, int base)

XDEF strtoul

strtoul:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   INCLUDE "../../z80/asm_strtoul.asm"
