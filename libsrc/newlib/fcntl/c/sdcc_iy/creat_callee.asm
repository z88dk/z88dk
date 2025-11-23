
; int creat_callee(const char *path, mode_t mode)

SECTION code_clib
SECTION code_fcntl

PUBLIC _creat_callee

EXTERN asm_creat

_creat_callee:

   pop af
   pop de
   pop bc
   push af

   jp asm_creat
