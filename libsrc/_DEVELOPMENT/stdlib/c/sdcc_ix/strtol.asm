
; long strtol( const char * restrict nptr, char ** restrict endptr, int base)

PUBLIC _strtol

_strtol:

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
   
   INCLUDE "stdlib/z80/asm_strtol.asm"
