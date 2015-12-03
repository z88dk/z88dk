
; FILE *fdopen_callee(int fd, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC fdopen_callee

EXTERN asm_fdopen

fdopen_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_fdopen
