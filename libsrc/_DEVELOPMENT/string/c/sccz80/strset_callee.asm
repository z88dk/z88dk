
; char* strset(char *s, int c)

SECTION code_string

PUBLIC strset_callee

strset_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strset.asm"
