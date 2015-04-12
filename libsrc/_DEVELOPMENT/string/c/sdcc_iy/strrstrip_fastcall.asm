
; char *strrstrip_fastcall(char *s)

SECTION code_string

PUBLIC _strrstrip_fastcall

_strrstrip_fastcall:

   INCLUDE "string/z80/asm_strrstrip.asm"
