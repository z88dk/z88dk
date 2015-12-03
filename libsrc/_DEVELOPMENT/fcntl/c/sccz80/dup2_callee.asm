
; int dup2(int fd, int fd2)

SECTION code_clib
SECTION code_fcntl

PUBLIC dup2_callee

EXTERN asm_dup2

dup2_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_dup2
