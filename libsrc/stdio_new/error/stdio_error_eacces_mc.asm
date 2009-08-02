; stdio_error_eacces_mc
; 06.2008 aralbrec

XLIB stdio_error_eacces_mc
LIB stdio_errno_mc

INCLUDE "../stdio.def"

.stdio_error_eacces_mc

   ld hl,EACCES
   jp stdio_errno_mc
