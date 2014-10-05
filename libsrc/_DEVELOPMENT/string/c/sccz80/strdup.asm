
; char *strdup(const char * s)

SECTION seg_code_string

PUBLIC strdup

strdup:

   INCLUDE "string/z80/asm_strdup.asm"
