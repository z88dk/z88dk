
; char *strchr(const char *s, int c)

XDEF strchr

strchr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af

   INCLUDE "string/z80/asm_strchr.asm"
