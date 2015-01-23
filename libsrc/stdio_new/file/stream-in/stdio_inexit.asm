; stdio_in_exit
; 05.2008 aralbrec

PUBLIC stdio_inexit
EXTERN stdio_ungetchar

; common code from stdio_in_* functions

.stdio_inexit

   call stdio_ungetchar
   scf
   ret
