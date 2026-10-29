
; int close(int fd)

SECTION code_clib
SECTION code_fcntl

PUBLIC close

EXTERN asm_close

close:

   push ix
   call asm_close
   pop ix
   ret
