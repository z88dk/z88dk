; stdio_error_enfile_zc
; 06.2008 aralbrec

XLIB stdio_error_enfile_zc
LIB stdio_errno_zc

INCLUDE "../stdio.def"

   pop hl
   
.stdio_error_enfile_zc

   ld hl,ENFILE
   jp stdio_errno_zc