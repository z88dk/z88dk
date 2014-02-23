
; int ungetc_unlocked(int c, FILE *stream)

XDEF ungetc_unlocked_callee

ungetc_unlocked_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   INCLUDE "../../z80/asm_ungetc_unlocked.asm"
