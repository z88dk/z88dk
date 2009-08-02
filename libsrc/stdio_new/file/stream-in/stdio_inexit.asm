; stdio_in_exit
; 05.2008 aralbrec

XLIB stdio_inexit
LIB stdio_ungetchar

; common code from stdio_in_* functions

.stdio_inexit

   call stdio_ungetchar
   scf
   ret
