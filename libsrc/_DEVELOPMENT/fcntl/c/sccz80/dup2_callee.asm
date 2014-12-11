
; int dup2(int fd, int fd2)

SECTION code_fcntl

PUBLIC dup2_callee

dup2_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "fcntl/z80/asm_dup2.asm"
