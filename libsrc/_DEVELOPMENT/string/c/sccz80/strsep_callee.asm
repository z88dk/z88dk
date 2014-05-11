
; char *strsep(char ** restrict stringp, const char * restrict delim)

PUBLIC strsep_callee

strsep_callee:

   pop af
   pop de
   pop bc
   push af
   
   INCLUDE "string/z80/asm_strsep.asm"
