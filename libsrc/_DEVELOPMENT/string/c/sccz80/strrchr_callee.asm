
; char *strrchr(const char *s, int c)

SECTION code_string

PUBLIC strrchr_callee

strrchr_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strrchr.asm"
