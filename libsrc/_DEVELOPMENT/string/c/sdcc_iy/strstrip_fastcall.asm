
; char *strstrip_fastcall(const char *s)

SECTION code_string

PUBLIC _strstrip_fastcall

_strstrip_fastcall:

   INCLUDE "string/z80/asm_strstrip.asm"
