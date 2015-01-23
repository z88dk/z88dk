; stdio_errno_mc
; 06.2008 aralbrec

PUBLIC stdio_errno_mc
EXTERN stdio_error_mc

EXTERN _errno

.stdio_errno_mc

   ld (_errno),hl
   jp stdio_error_mc
