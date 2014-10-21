
; FILE *fdopen_callee(int fd, const char *mode)

SECTION seg_code_stdio

PUBLIC fdopen_callee

fdopen_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_fdopen.asm"
