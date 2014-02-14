
; int _strtoi(const char *nptr, char **endptr, int base)

XDEF _strtoi

_strtoi:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm__strtoi.asm"
