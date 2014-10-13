
; size_t getdelim_unlocked(char **lineptr, size_t *n, int delimiter, FILE *stream)

SECTION seg_code_stdio

PUBLIC getdelim_unlocked_callee

getdelim_unlocked_callee:

   pop hl
   pop ix
   pop bc
   pop de
   ex (sp),hl

   INCLUDE "stdio/z80/asm_getdelim_unlocked.asm"
