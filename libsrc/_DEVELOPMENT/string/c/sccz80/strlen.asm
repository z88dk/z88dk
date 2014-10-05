
; size_t strlen(const char *s)

SECTION seg_code_string

PUBLIC strlen

strlen:

   INCLUDE "string/z80/asm_strlen.asm"
