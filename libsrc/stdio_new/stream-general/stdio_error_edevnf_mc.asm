; stdio_error_edevnf_mc
; 06.2008 aralbrec

XLIB stdio_error_edevnf_mc
LIB stdio_errno_mc

INCLUDE "stdio.def"

.stdio_error_edevnf_mc

   ld hl,EDEVNF
   jp stdio_errno_mc
