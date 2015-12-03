
; int vopen_callee(const char *path, int oflag, void *arg)

SECTION code_clib
SECTION code_fcntl

PUBLIC _vopen_callee, l0_vopen_callee

EXTERN asm_vopen

_vopen_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl

l0_vopen_callee:

   push ix
   
   call asm_vopen
   
   pop ix
   ret
