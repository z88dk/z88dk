
; void call_once_callee(once_flag *flag, void (*func)(void))

SECTION code_threads_mutex

PUBLIC _call_once_callee, l0_call_once_callee

_call_once_callee:

   pop af
   pop hl
   pop de
   push af

l0_call_once_callee:
   
   push ix
   
   call asm_call_once
   
   pop ix
   ret
   
   INCLUDE "threads/mutex/z80/asm_call_once.asm"
