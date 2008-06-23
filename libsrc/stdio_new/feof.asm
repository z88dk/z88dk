; int __FASTCALL__ feof(FILE *stream)
; 06.2008 aralbrec

XLIB feof
LIB stdio_error_mc, stdio_success_znc, l_jpix

INCLUDE "stdio.def"

.feof

   push hl
   pop ix

   bit 2,(ix+3)                ; open for input?
   jp nz, stdio_success_znc    ; if no indicate not eof
   
   bit 0,(ix+3)                ; unget char available?
   jp nz, stdio_success_znc    ; if yes indicate not eof
   
   ld c,STDIO_MSG_FEOF
   call l_jpix
   jp c, stdio_error_mc        ; return eof true
   jp stdio_success_znc
