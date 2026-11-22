
; void call_once_callee(once_flag *flag, void (*func)(void))

SECTION code_clib
SECTION code_threads_mutex

PUBLIC call_once_callee

EXTERN asm_call_once

call_once_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_call_once
