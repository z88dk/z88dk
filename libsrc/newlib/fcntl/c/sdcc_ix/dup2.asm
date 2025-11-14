
; int dup2(int fd, int fd2)

SECTION code_clib
SECTION code_fcntl

PUBLIC _dup2

EXTERN l0_dup2_callee

_dup2:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp l0_dup2_callee
