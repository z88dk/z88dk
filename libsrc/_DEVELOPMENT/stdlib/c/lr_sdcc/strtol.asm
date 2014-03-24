
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
   
   push ix
   
   call asm_strtol
   
   pop ix
   ret
   
   INCLUDE "stdlib/z80/asm_strtol.asm"
