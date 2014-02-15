
; char *strlwr(char *s)

XDEF strlwr

strlwr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_strlwr.asm"
