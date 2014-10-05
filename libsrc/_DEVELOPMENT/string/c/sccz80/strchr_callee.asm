
; char *strchr(const char *s, int c)

SECTION seg_code_string

PUBLIC strchr_callee

strchr_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strchr.asm"
