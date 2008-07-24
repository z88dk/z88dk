; stdio_error_mc
; 06.2008 aralbrec

XLIB stdio_error_mc

XDEF _errno

._errno defb 0

; exit : hl = -1 and carry set

.stdio_error_mc

   ld hl,-1
   scf
   ret
