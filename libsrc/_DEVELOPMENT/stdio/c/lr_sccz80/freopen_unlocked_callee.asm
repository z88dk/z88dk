
; FILE *freopen_unlocked(char *filename, char *mode, FILE *stream)

XDEF freopen_unlocked_callee

freopen_unlocked_callee:

   pop hl
   pop ix
   pop de
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_freopen_unlocked.asm"
