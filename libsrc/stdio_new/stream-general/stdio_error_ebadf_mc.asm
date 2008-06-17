; stdio_error_ebadf_mc
; 06.2008 aralbrec

XLIB stdio_error_ebadf_mc
LIB stdio_error_ebadf_zc

.stdio_error_ebadf_mc

   call stdio_error_ebadf_zc
   dec hl
   ret
