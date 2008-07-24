; stdio_error_einval_mc
; 06.2008 aralbrec

XLIB stdio_error_einval_mc
LIB stdio_errno_mc

INCLUDE "stdio.def"


.stdio_error_einval_mc

   ld hl,EINVAL
   jp stdio_errno_mc
