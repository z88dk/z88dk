
; int creat(const char *path, mode_t mode)

SECTION code_clib
SECTION code_fcntl

PUBLIC _creat

EXTERN l0_creat_callee

_creat:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af

   jp l0_creat_callee
