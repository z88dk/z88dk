
; char *strlwr_fastcall(char *s)

SECTION code_string

PUBLIC _strlwr_fastcall

_strlwr_fastcall:

   INCLUDE "string/z80/asm_strlwr.asm"
