; stdio_error_eacces_mc
; 06.2008 aralbrec

XLIB stdio_error_eacces_mc
LIB stdio_error_eacces_zc

.stdio_error_eacces_mc

   call stdio_error_eacces_zc
   dec hl
   ret
