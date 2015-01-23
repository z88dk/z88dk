; stdio_idle
; 08.2009 aralbrec

PUBLIC stdio_idle
EXTERN stdio_statesave, stdio_staterestore

; The library calls this function when it is waiting for data
; to be written or read from a device that is not ready.  This
; could be an opportunity for a context switch in a multitasking
; environment.

.stdio_idle

   ; call stdio_statesave        ; push all registers to stack
   
   ; insert code here
   
   ; call stdio_staterestore     ; pop all registers from stack

   ret
