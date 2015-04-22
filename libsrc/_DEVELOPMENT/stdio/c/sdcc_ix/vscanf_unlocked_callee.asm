
; int vscanf_unlocked_callee(const char *format, void *arg)

SECTION code_stdio

PUBLIC _vscanf_unlocked_callee, l0_vscanf_unlocked_callee

_vscanf_unlocked_callee:

   pop af
   pop de
   pop bc
   push af

l0_vscanf_unlocked_callee:

   push ix
   
   call asm_vscanf_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_vscanf_unlocked.asm"
