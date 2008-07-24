; stdio_error_enomem_mc
; 06.2008 aralbrec

XLIB stdio_error_enomem_mc
LIB stdio_errno_mc

INCLUDE "stdio.def"


.stdio_error_enomem_mc

   ld hl,ENOMEM
   jp stdio_errno_mc
