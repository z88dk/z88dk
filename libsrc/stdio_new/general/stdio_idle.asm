; stdio_idle
; 08.2009 aralbrec

XLIB stdio_idle

; The library calls this function when it is waiting for data
; to be written or read from a device that is not ready.  This
; could be an opportunity for a context switch in a multitasking
; environment.

.stdio_idle

   ret
