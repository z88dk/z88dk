
; int vopen(const char *path, int oflag, void *arg)

SECTION code_clib
SECTION code_fcntl

PUBLIC _vopen

EXTERN l0_vopen_callee

_vopen:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af

   jp l0_vopen_callee
