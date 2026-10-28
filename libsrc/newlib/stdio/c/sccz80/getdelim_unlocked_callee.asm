
; size_t getdelim_unlocked(char **lineptr, size_t *n, int delimiter, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC getdelim_unlocked_callee

EXTERN asm_getdelim_unlocked

getdelim_unlocked_callee:

   pop hl
   pop af
   pop bc
   pop de
   ex (sp),hl

   push ix
   push af
   pop ix

   call asm_getdelim_unlocked
   pop ix
   ret
