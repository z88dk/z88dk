
; int close(int fd)

SECTION code_fcntl

PUBLIC close

close:

   INCLUDE "fcntl/z80/asm_close.asm"
