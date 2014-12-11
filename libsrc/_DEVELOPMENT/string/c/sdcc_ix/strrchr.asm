
; char *strrchr(const char *s, int c)

SECTION code_string

PUBLIC _strrchr

_strrchr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "string/z80/asm_strrchr.asm"
