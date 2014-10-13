
; FILE *fopen(const char *filename, const char *mode);

SECTION seg_code_stdio

PUBLIC fopen_callee

fopen_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_fopen.asm"
