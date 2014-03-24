
; size_t getdelim(char **lineptr, size_t *n, int delimiter, FILE *stream)

XDEF getdelim_callee

getdelim_callee:

   pop hl
   pop ix
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_getdelim.asm"
