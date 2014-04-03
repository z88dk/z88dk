
; char *_strrstrip_(const char *s)

XDEF __strrstrip_

__strrstrip_:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "string/z80/asm__strrstrip.asm"
