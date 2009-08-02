; stdio_errno_zc
; 06.2008 aralbrec

XLIB stdio_errno_zc
LIB stdio_error_zc
XREF _errno

.stdio_errno_zc

   ld (_errno),hl
   jp stdio_error_zc
