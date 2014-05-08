
; char *strdup(const char * s)

PUBLIC _strdup

_strdup:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "string/z80/asm_strdup.asm"
