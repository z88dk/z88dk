
; int _strtoi_(const char *nptr, char **endptr, int base)

PUBLIC _strtoi__callee

_strtoi__callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "stdlib/z80/asm__strtoi.asm"
