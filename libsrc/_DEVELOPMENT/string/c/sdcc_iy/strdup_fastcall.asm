
; char *strdup_fastcall(const char * s)

SECTION code_string

PUBLIC _strdup_fastcall

_strdup_fastcall:
   
   INCLUDE "string/z80/asm_strdup.asm"
