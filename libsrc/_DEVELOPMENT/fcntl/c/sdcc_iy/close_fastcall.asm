
; int close_fastcall(int fd)

SECTION code_fcntl

PUBLIC _close_fastcall

_close_fastcall:
   
   INCLUDE "fcntl/z80/asm_close.asm"
