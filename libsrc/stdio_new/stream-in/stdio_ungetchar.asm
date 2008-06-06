; stdio_ungetchar
; 05.2008 aralbrec

XLIB stdio_ungetchar

; stream guarantees exactly one unget char
;
; enter : ix = FILE *
;         bc' = number of chars read thus far
;         de' = number of conversions done thus far
;          a  = char to unget
; exit  : bc' = number of chars read thus far
;         de' = number of conversions done thus far
;         carry reset
; uses  : af, exx

.stdio_ungetchar

   ld (ix+4),a                 ; store unget char
   set 0,(ix+3)                ; indicate unget char present
   
   exx
   dec bc                      ; decrease number of bytes read from stream
   exx
   
   or a
   ret
