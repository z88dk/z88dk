
; size_t strlen(const char *s)

XDEF _strlen

_strlen:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "string/z80/asm_strlen.asm"
