
; size_t strnlen(const char *s, size_t maxlen)

XDEF strnlen_callee

strnlen_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_strnlen.asm"
