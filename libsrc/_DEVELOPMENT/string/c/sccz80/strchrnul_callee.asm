
; char *strchrnul(const char *s, int c)

PUBLIC strchrnul_callee

strchrnul_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strchrnul.asm"
