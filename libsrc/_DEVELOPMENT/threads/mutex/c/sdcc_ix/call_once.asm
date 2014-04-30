
; void call_once(once_flag *flag, void (*func)(void))

XDEF call_once

call_once:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   push ix
   
   call asm_call_once
   
   pop ix
   ret
   
   INCLUDE "threads/mutex/z80/asm_call_once.asm"
