; stdio_success
; 05.2008 aralbrec

XLIB stdio_success

; common code indicating success
;
; exit : hl = 1 and carry reset

.stdio_success

   ld hl,1
   or a
   ret
