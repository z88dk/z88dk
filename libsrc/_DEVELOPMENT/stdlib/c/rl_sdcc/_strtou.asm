
; unsigned int _strtou(const char *nptr, char **endptr, int base)

XDEF _strtou

_strtou:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm__strtou.asm"
