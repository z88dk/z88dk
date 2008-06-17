; stdio_error_enomem_mc
; 06.2008 aralbrec

XLIB stdio_error_enomem_mc
LIB stdio_error_enomem_zc

.stdio_error_enomem_mc

   call stdio_error_enomem_zc
   dec hl
   ret
