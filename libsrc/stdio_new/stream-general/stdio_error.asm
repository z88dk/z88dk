; stdio_error
; 05.2008 aralbrec

XLIB stdio_error

; common code exiting with error
;
; exit : hl = -1 and carry set

.stdio_error

   ld hl,-1
   scf
   ret
