
; size_t strspn(const char *s1, const char *s2)

XDEF strspn_callee

strspn_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strspn.asm"
