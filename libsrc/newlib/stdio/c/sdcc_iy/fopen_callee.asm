
; FILE *fopen_callee(const char *filename, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC _fopen_callee

EXTERN asm_fopen

_fopen_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_fopen
