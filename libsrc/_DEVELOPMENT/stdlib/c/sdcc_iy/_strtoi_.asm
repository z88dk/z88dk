
; int _strtoi_(const char *nptr, char **endptr, int base)

SECTION code_stdlib

PUBLIC __strtoi_

__strtoi_:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "stdlib/z80/asm__strtoi.asm"
