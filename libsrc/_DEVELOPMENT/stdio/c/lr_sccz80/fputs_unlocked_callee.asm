
; int fputs_unlocked(const char *s, FILE *stream)

XDEF fputs_unlocked_callee

fputs_unlocked_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   INCLUDE "../../z80/asm_fputs_unlocked.asm"
