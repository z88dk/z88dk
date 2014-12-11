
; char *strsep(char ** restrict stringp, const char * restrict delim)

SECTION code_string

PUBLIC _strsep

_strsep:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   INCLUDE "string/z80/asm_strsep.asm"
