
; int fputs(const char *s, FILE *stream)

XDEF fputs_callee

fputs_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   INCLUDE "../../z80/asm_fputs.asm"
