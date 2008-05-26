; stdio_consumews
; 05.2008 aralbrec

XLIB stdio_consumews
LIB stdio_getchar, stdio_ungetchar, stdio_isspace

; consume whitespace chars from the input stream

; enter : ix = & attached file / device getchar function
; uses  : af

.stdio_consumews

   call stdio_getchar
   ret c                       ; ret if EOF reached
   
   call stdio_isspace          ; is it a whitespace char?
   jr z, stdio_consumews
   
   jp stdio_ungetchar          ; place non-whitespace char back on stream
