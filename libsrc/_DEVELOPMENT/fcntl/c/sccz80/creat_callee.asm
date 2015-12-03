
; int creat(const char *path, mode_t mode)

SECTION code_clib
SECTION code_fcntl

PUBLIC creat_callee

EXTERN asm_creat

creat_callee:

   pop af
   pop bc
   pop de
   push af
   
   jp asm_creat
