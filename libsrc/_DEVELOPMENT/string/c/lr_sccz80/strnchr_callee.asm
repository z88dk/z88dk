
; char *strnchr(const char *s, size_t n, int c)

PUBLIC strnchr_callee

strnchr_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strnchr.asm"
