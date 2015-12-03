
; int dup2_callee(int fd, int fd2)

SECTION code_clib
SECTION code_fcntl

PUBLIC _dup2_callee

EXTERN asm_dup2

_dup2:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_dup2
