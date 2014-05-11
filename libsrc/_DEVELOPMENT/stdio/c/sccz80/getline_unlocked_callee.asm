
; size_t getline_unlocked(char **lineptr, size_t *n, FILE *stream)

PUBLIC getline_unlocked_callee

getline_unlocked_callee:

   pop hl
   pop ix
   pop de
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_getline_unlocked.asm"
