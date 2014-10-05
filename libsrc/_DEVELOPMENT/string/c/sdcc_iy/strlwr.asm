
; char *strlwr(char *s)

SECTION seg_code_string

PUBLIC _strlwr

_strlwr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "string/z80/asm_strlwr.asm"
