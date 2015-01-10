
; char *strnset(char *s, int c, size_t n)

SECTION code_string

PUBLIC _strnset

_strnset:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "string/z80/asm_strnset.asm"
