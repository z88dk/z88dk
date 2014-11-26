
; int dup2(int fd, int fd2)

SECTION seg_code_fcntl

PUBLIC _dup2

_dup2:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   push ix
   
   call asm_dup2
   
   pop ix
   ret
   
   INCLUDE "fcntl/z80/asm_dup2.asm"
