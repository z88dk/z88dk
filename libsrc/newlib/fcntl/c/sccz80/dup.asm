
; int dup(int fd)

SECTION code_clib
SECTION code_fcntl

PUBLIC dup

EXTERN asm_dup

dup:

   push ix
   call asm_dup
   pop ix
   ret
