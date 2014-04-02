
; char *_strrstrip(const char *s)

XDEF __strrstrip

__strrstrip:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "string/z80/asm__strrstrip.asm"
