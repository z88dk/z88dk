
; FILE *freopen_unlocked(char *filename, char *mode, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC freopen_unlocked_callee

EXTERN asm_freopen_unlocked

freopen_unlocked_callee:

   pop hl
   pop ix
   pop de
   ex (sp),hl
   
   jp asm_freopen_unlocked
