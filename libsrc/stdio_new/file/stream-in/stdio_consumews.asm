; stdio_consumews
; 05.2008 aralbrec

PUBLIC stdio_consumews
EXTERN stdio_getchar, stdio_ungetchar, asm_isspace

; consume whitespace chars from the input stream

; enter : ix = FILE *
; uses  : af

.stdio_consumews

   call stdio_getchar
   ret c                       ; ret if EOF reached
   
   call asm_isspace            ; is it a whitespace char?
   jr z, stdio_consumews
   
   jp stdio_ungetchar          ; place non-whitespace char back on stream
