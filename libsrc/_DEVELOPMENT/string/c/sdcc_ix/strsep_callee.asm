
; char *strsep_callee(char ** restrict stringp, const char * restrict delim)

SECTION code_string

PUBLIC _strsep_callee

_strsep_callee:

   pop af
   pop bc
   pop de
   push af
   
   INCLUDE "string/z80/asm_strsep.asm"
