
; char *strchr(const char *s, int c)

XDEF strchr

strchr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_strchr.asm"
