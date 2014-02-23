
; size_t getline(char **lineptr, size_t *n, FILE *stream)

XDEF getline_callee

getline_callee:

   pop hl
   pop ix
   pop de
   ex (sp),hl
   
   INCLUDE "../../z80/asm_getline.asm"
