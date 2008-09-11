; stdio_error_mc
; 06.2008 aralbrec

XLIB stdio_error_mc

; exit : hl = -1 and carry set

.stdio_error_mc

   ld hl,-1
   scf
   ret
