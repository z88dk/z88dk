
; char *strrev_fastcall(char *s)

SECTION code_string

PUBLIC _strrev_fastcall

_strrev_fastcall:

   INCLUDE "string/z80/asm_strrev.asm"
