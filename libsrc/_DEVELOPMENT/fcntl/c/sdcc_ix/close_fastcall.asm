
; int close_fastcall(int fd)

SECTION code_fcntl

PUBLIC _close_fastcall

_close_fastcall:
   
   push ix
   
   call asm_close
   
   pop ix
   ret

   INCLUDE "fcntl/z80/asm_close.asm"
