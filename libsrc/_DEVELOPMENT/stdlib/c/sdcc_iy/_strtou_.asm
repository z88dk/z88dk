
; unsigned int _strtou_(const char *nptr, char **endptr, int base)

SECTION seg_code_stdlib

PUBLIC __strtou_

__strtou_:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "stdlib/z80/asm__strtou.asm"
