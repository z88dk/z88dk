
; void call_once(once_flag *flag, void (*func)(void))

SECTION seg_code_mutex

PUBLIC call_once

EXTERN asm_call_once

call_once:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_call_once
