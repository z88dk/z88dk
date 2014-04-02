
; char *strrchr(const char *s, int c)

XDEF _strrchr

_strrchr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "string/z80/asm_strrchr.asm"
