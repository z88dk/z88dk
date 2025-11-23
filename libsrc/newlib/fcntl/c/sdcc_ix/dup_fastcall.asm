
; int dup_fastcall(int fd)

SECTION code_clib
SECTION code_fcntl

PUBLIC _dup_fastcall

EXTERN asm_dup

_dup_fastcall:
   
   push ix
   
   call asm_dup
   
   pop ix
   ret
