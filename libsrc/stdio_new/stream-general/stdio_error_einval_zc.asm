; stdio_error_einval_zc
; 06.2008 aralbrec

XLIB stdio_error_einval_zc
XREF _errno

INCLUDE "stdio.def"

   pop hl
   pop hl

.stdio_error_einval_zc

   ld hl,EINVAL
   ld (_errno),hl
   ld l,0
   scf
   ret
