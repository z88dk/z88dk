
; size_t strlen(const char *s)

XDEF strlen

strlen:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "../../z80/asm_strlen.asm"
