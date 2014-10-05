
; int strcoll(const char *s1, const char *s2)

SECTION seg_code_string

PUBLIC strcoll_callee

strcoll_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strcoll.asm"
