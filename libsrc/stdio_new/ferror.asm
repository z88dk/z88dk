; int __FASTCALL__ ferror(FILE *stream)
; 06.2008 aralbrec

XLIB ferror
LIB l_jphl

INCLUDE "stdio.def"

.ferror

   push hl
   pop ix

   ld c,STDIO_MSG_FERR
   call l_jphl
   
   ld h,0
   ld l,a
   or a
   
   bit 0,(ix+3)                ; unget char available?
   ret z                       ; if no return
   
   res 7,l                     ; otherwise its not eof
   ret
