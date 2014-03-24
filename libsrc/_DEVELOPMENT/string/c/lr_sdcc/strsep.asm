
; char *strsep(char ** restrict stringp, const char * restrict delim)

XDEF strsep

strsep:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   INCLUDE "string/z80/asm_strsep.asm"
