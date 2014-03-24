
; char *strndup(const char *s, size_t n)

XDEF strndup_callee

strndup_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strndup.asm"
