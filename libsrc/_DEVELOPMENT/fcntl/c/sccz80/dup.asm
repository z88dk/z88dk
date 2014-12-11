
; int dup(int fd)

SECTION code_fcntl

PUBLIC dup

dup:

   INCLUDE "fcntl/z80/asm_dup.asm"
