; stdio_error_eacces_zc
; 06.2008 aralbrec

XLIB stdio_error_eacces_zc
LIB stdio_errno_zc

INCLUDE "stdio.def"

.stdio_error_eacces_zc

   ld hl,EACCES
   jp stdio_errno_zc
