
; char *strncat(char * restrict s1, const char * restrict s2, size_t n)

PUBLIC _strncat

_strncat:

   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   
   INCLUDE "string/z80/asm_strncat.asm"
