
; long strtol( const char * restrict nptr, char ** restrict endptr, int base)

XDEF strtol

strtol:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   push ix
   
   call asm_strtol
   
   pop ix
   ret
   
   INCLUDE "../../z80/asm_strtol.asm"
