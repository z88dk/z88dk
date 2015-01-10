
; char* strset(char *s, int c)

SECTION code_string

PUBLIC _strset

_strset:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "string/z80/asm_strset.asm"
