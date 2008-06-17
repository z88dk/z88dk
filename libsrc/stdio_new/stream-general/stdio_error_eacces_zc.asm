; stdio_error_eacces_zc
; 06.2008 aralbrec

XLIB stdio_error_eacces_zc
XREF _errno

INCLUDE "stdio.def"

.stdio_error_eacces_zc

   ld hl,EACCES
   ld (_errno),hl
   ld l,0
   scf
   ret
