
; int _strtoi(const char *nptr, char **endptr, int base)

XDEF __strtoi

__strtoi:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "stdlib/z80/asm__strtoi.asm"
