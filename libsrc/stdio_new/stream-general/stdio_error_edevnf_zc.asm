; stdio_error_edevnf_zc
; 06.2008 aralbrec

XLIB stdio_error_edevnf_zc
LIB stdio_errno_zc

INCLUDE "stdio.def"

.stdio_error_edevnf_zc

   ld hl,EDEVNF
   jp stdio_errno_zc
