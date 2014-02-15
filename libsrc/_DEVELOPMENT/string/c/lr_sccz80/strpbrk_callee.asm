
; char *strpbrk(const char *s1, const char *s2)

XDEF strpbrk_callee

strpbrk_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "../../z80/asm_strpbrk.asm"
