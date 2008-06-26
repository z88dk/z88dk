; stdio_error_enomem_mc
; 06.2008 aralbrec

XLIB stdio_error_enomem_mc
LIB stdio_errorno_mc

INCLUDE "stdio.def"

   pop hl
   pop hl

.stdio_error_enomem_mc

   ld hl,ENOMEM
   jp stdio_errno_mc
