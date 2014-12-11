
; size_t strrspn(const char *str, const char *cset)

SECTION code_string

PUBLIC strrspn_callee

strrspn_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strrspn.asm"
