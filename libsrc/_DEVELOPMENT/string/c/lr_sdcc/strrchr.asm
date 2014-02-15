
; char *strrchr(const char *s, int c)

XDEF strrchr

strrchr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_strrchr.asm"
