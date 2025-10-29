
; size_t getdelim_unlocked(char **lineptr, size_t *n, int delimiter, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC getdelim_unlocked_callee

EXTERN asm_getdelim_unlocked

getdelim_unlocked_callee:

   pop hl
   pop ix
   pop bc
   pop de
   ex (sp),hl

   jp asm_getdelim_unlocked
