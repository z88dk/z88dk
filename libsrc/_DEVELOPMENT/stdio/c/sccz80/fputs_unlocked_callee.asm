
; int fputs_unlocked(const char *s, FILE *stream)

SECTION code_stdio

PUBLIC fputs_unlocked_callee

fputs_unlocked_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   INCLUDE "stdio/z80/asm_fputs_unlocked.asm"
