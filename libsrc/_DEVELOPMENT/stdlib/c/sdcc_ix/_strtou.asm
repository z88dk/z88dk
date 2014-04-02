
; unsigned int _strtou(const char *nptr, char **endptr, int base)

XDEF __strtou

__strtou:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "stdlib/z80/asm__strtou.asm"
