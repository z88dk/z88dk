
; int creat(const char *path, mode_t mode)

SECTION code_clib
SECTION code_fcntl

PUBLIC creat

EXTERN asm_creat

creat:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   jp asm_creat
