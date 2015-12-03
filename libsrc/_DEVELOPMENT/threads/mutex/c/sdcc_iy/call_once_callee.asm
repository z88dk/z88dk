
; void call_once_callee(once_flag *flag, void (*func)(void))

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _call_once_callee, l0_call_once_callee

EXTERN asm_call_once

_call_once_callee:

   pop af
   pop hl
   pop de
   push af

l0_call_once_callee:

   push iy
   
   call asm_call_once
   
   pop iy
   ret
