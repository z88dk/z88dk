
; size_t strlen(const char *s)

SECTION code_string

PUBLIC strlen

strlen:

   INCLUDE "string/z80/asm_strlen.asm"
