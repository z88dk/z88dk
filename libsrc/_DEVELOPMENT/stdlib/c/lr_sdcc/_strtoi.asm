
; int _strtoi(const char *nptr, char **endptr, int base)

XDEF _strtoi

_strtoi:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   INCLUDE "stdlib/z80/asm__strtoi.asm"
