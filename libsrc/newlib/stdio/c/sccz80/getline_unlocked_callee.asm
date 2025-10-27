
; size_t getline_unlocked(char **lineptr, size_t *n, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC getline_unlocked_callee

EXTERN asm_getline_unlocked

getline_unlocked_callee:

   pop hl
   pop ix
   pop de
   ex (sp),hl
   
   jp asm_getline_unlocked
