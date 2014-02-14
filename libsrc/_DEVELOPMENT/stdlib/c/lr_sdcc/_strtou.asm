
; unsigned int _strtou(const char *nptr, char **endptr, int base)

XDEF _strtou

_strtou:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   INCLUDE "../../z80/asm__strtou.asm"
