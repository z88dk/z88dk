; int __FASTCALL__ ferror(FILE *stream)
; 06.2008 aralbrec

XLIB ferror
LIB l_jphl

INCLUDE "stdio.def"

.ferror

   ld c,STDIO_MSG_FERR
   call l_jphl
   
   ld h,0
   or a
   ret
