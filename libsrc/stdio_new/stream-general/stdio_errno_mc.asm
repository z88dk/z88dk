; stdio_errno_mc
; 06.2008 aralbrec

XLIB stdio_errno_mc
LIB stdio_error_mc
XREF _errno

.stdio_errno_mc

   ld (_errno),hl
   jp stdio_error_mc
