
; int dup(int fd)

SECTION seg_code_fcntl

PUBLIC dup

dup:

   INCLUDE "fcntl/z80/asm_dup.asm"
