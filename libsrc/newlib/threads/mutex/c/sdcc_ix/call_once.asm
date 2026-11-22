
; void call_once(once_flag *flag, void (*func)(void))

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _call_once

EXTERN l0_call_once_callee

_call_once:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp l0_call_once_callee
