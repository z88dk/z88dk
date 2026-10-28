
; FILE *freopen_unlocked(char *filename, char *mode, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC freopen_unlocked_callee

EXTERN asm_freopen_unlocked

freopen_unlocked_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

   push ix
   push bc
   pop ix

   call asm_freopen_unlocked
   pop ix
   ret
