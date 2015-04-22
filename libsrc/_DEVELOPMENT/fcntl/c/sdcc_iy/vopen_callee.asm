
; int vopen_callee(const char *path, int oflag, void *arg)

SECTION code_fcntl

PUBLIC _vopen_callee

_vopen_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "fcntl/z80/asm_vopen.asm"
