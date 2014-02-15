
; size_t strrcspn(const char *str, const char *cset)

XDEF strrcspn_callee

strrcspn_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "../../z80/asm_strrcspn.asm"
