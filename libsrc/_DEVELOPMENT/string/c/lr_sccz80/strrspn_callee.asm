
; size_t strrspn(const char *str, const char *cset)

XDEF strrspn_callee

strrspn_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "../../z80/asm_strrspn.asm"
