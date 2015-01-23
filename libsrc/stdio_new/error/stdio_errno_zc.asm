; stdio_errno_zc
; 06.2008 aralbrec

PUBLIC stdio_errno_zc
EXTERN stdio_error_zc
EXTERN _errno

.stdio_errno_zc

   ld (_errno),hl
   jp stdio_error_zc
