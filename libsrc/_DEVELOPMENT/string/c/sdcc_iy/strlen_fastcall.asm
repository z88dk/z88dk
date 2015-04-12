
; size_t strlen_fastcall(const char *s)

SECTION code_string

PUBLIC _strlen_fastcall

_strlen_fastcall:
   
   INCLUDE "string/z80/asm_strlen.asm"
