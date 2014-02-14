
; unsigned int _strtou(const char *nptr, char **endptr, int base)

XDEF _strtou_callee

_strtou_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "../../z80/asm__strtou.asm"
