
; int creat(const char *path, mode_t mode)

SECTION code_clib
SECTION code_fcntl

PUBLIC _creat

EXTERN asm_creat

_creat:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af

   jp asm_creat
