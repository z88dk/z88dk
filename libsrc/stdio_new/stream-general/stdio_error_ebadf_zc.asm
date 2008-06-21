; stdio_error_ebadf_zc
; 06.2008 aralbrec

XLIB stdio_error_ebadf_zc
LIB stdio_errno_zc

INCLUDE "stdio.def"

.stdio_error_ebadf_zc

   ld hl,EBADF
   jp stdio_errno_zc
