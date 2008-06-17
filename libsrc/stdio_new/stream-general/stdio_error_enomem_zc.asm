; stdio_error_enomem_zc
; 06.2008 aralbrec

XLIB stdio_error_enomem_zc
XREF _errno

INCLUDE "stdio.def"

   pop hl
   pop hl

.stdio_error_enomem_zc

   ld hl,ENOMEM
   ld (_errno),hl
   ld l,0
   scf
   ret
