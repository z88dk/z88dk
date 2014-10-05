
; char *strstrip(const char *s)

SECTION seg_code_string

PUBLIC _strstrip

_strstrip:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "string/z80/asm_strstrip.asm"
