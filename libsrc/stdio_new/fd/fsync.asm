; int __FASTCALL__ fsync(int fd)
; 06.2008 aralbrec

XLIB fsync

LIB l_jpix, fd_common1
LIB stdio_error_mc, stdio_success_znc

INCLUDE "stdio.def"

.fsync

   call fd_common1             ; ix = fdstruct
   ret c

   ld c,STDIO_MSG_SYNC
   call l_jpix
   jp nc, stdio_success_znc
   
   jp stdio_error_mc
