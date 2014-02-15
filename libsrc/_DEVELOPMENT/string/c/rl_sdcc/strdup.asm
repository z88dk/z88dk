
; char *strdup(const char * s)

XDEF strdup

strdup:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "../../z80/asm_strdup.asm"
