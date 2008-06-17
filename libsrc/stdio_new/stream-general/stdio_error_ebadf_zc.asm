; stdio_error_ebadf_zc
; 06.2008 aralbrec

XLIB stdio_error_ebadf_zc
XREF _errno

INCLUDE "stdio.def"

.stdio_error_ebadf_zc

   ld hl,EBADF
   ld (_errno),hl
   ld l,0
   scf
   ret
