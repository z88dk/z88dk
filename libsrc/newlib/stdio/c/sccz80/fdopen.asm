
; FILE *fdopen(int fd, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC fdopen

EXTERN asm_fdopen

fdopen:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_fdopen
