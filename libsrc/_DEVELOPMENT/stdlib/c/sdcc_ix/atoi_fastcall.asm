
; int atoi_fastcall(const char *buf)

SECTION code_stdlib

PUBLIC _atoi_fastcall

_atoi_fastcall:

   INCLUDE "stdlib/z80/asm_atoi.asm"
