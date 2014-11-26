
; int close(int fd)

SECTION seg_code_fcntl

PUBLIC close

close:

   INCLUDE "fcntl/z80/asm_close.asm"
