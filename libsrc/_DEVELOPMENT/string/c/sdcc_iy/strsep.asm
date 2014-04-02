
; char *strsep(char ** restrict stringp, const char * restrict delim)

XDEF _strsep

_strsep:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   INCLUDE "string/z80/asm_strsep.asm"
