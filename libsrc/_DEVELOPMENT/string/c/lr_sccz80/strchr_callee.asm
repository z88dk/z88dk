
; char *strchr(const char *s, int c)

PUBLIC strchr_callee

strchr_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strchr.asm"
