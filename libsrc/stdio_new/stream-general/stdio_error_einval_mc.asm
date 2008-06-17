; stdio_error_einval_mc
; 06.2008 aralbrec

XLIB stdio_error_einval_mc
LIB stdio_error_einval_zc

.stdio_error_einval_mc

   call stdio_error_einval_zc
   dec hl
   ret
