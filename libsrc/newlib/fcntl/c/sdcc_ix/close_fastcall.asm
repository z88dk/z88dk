
; int close_fastcall(int fd)

SECTION code_clib
SECTION code_fcntl

PUBLIC _close_fastcall

EXTERN asm_close

_close_fastcall:
   
   push ix
   
   call asm_close
   
   pop ix
   ret
