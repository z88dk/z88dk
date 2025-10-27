
; int dup2(int fd, int fd2)

SECTION code_clib
SECTION code_fcntl

PUBLIC _dup2

EXTERN asm_dup2

_dup2:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_dup2
