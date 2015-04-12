
; int dup_fastcall(int fd)

SECTION code_fcntl

PUBLIC _dup_fastcall

_dup_fastcall:

   INCLUDE "fcntl/z80/asm_dup.asm"
