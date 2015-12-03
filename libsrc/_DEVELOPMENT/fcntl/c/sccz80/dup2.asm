
; int dup2(int fd, int fd2)

SECTION code_clib
SECTION code_fcntl

PUBLIC dup2

EXTERN asm_dup2

dup2:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dup2
