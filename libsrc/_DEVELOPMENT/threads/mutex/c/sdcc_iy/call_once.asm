
; void call_once(once_flag *flag, void (*func)(void))

PUBLIC call_once

call_once:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   push iy
   
   call asm_call_once
   
   pop iy
   ret
   
   INCLUDE "threads/mutex/z80/asm_call_once.asm"
