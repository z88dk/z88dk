
; int vopen_callee(const char *path, int oflag, void *arg)

SECTION code_clib
SECTION code_fcntl

PUBLIC _vopen_callee

EXTERN asm_vopen

_vopen_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_vopen
