
; char *strtok(char * restrict s1, const char * restrict s2)

PUBLIC _strtok

_strtok:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "string/z80/asm_strtok.asm"
