
; char *strdup(const char * s)

SECTION code_string

PUBLIC strdup

strdup:

   INCLUDE "string/z80/asm_strdup.asm"
