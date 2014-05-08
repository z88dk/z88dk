
; size_t strrcspn(const char *str, const char *cset)

PUBLIC strrcspn_callee

strrcspn_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strrcspn.asm"
