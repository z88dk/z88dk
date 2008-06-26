; int __FASTCALL__ readbyte(int fd)
; 06.2008 aralbrec

XLIB readbyte

LIB stdio_error_eacces_mc, stdio_error_mc
LIB l_jpix, fd_common1

INCLUDE "stdio.def"

.readbyte

   call fd_common1             ; ix = fdstruct
   ret c
   
   bit 2,(ix+3)                ; open for reading?
   jp z, stdio_error_eacces_mc

   ld c,STDIO_MSG_GETC
   call l_jpix
   jp c, stdio_error_mc
   
   ld l,a
   ld h,0
   ret
