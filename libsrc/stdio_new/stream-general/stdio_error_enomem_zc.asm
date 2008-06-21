; stdio_error_enomem_zc
; 06.2008 aralbrec

XLIB stdio_error_enomem_zc
LIB stdio_errno_zc

INCLUDE "stdio.def"

   pop hl
   pop hl

.stdio_error_enomem_zc

   ld hl,ENOMEM
   jp stdio_errno_zc
