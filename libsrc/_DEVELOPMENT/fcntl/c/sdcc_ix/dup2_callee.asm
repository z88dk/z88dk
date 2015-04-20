
; int dup2_callee(int fd, int fd2)

SECTION code_fcntl

PUBLIC _dup2_callee, l0_dup2_callee

_dup2_callee:

   pop af
   pop hl
   pop de
   push af

l0_dup2_callee:

   push ix
   
   call asm_dup2
   
   pop ix
   ret
   
   INCLUDE "fcntl/z80/asm_dup2.asm"
