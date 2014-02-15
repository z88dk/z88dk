
; char *strnchr(const char *s, size_t n, int c)

XDEF strnchr

strnchr:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "../../z80/asm_strnchr.asm"
