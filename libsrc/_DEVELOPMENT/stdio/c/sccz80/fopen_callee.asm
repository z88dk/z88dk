
; FILE *fopen(const char *filename, const char *mode)

SECTION code_clib
SECTION code_stdio

PUBLIC fopen_callee

EXTERN asm_fopen

fopen_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_fopen
