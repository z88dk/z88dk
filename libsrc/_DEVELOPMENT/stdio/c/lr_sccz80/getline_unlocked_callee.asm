
; size_t getline_unlocked(char **lineptr, size_t *n, FILE *stream)

XDEF getline_unlocked_callee

getline_unlocked_callee:

   pop hl
   pop ix
   pop de
   ex (sp),hl
   
   INCLUDE "../../z80/asm_getline_unlocked.asm"
