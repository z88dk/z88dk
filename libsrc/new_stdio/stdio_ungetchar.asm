; stdio_ungetchar
; 05.2008 aralbrec

XLIB stdio_ungetchar

; stream guarantees exactly one unget char
;
; enter : ix = & attached file / device getchar function
;         bc' = number of chars read thus far
;         de' = number of conversions done thus far
;          a  = char to unget
; exit  : bc' = number of chars read thus far
;         de' = number of conversions done thus far
;         carry reset
; uses  : af, exx

.stdio_ungetchar

   ld (ix-1),a                 ; store unget char
   set 0,(ix-2)                ; indicate unget char present
   
   exx
   dec bc                      ; decrease number of bytes read from stream
   exx
   
   or a
   ret
