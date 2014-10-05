
; unsigned int _strtou_(const char *nptr, char **endptr, int base)

SECTION seg_code_stdlib

PUBLIC _strtou__callee

_strtou__callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "stdlib/z80/asm__strtou.asm"
