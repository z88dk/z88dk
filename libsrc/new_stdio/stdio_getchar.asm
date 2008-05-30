; stdio_getchar
; 05.2008 aralbrec

XLIB stdio_getchar
LIB l_jpix

; all character input from stream is read through this function
;
; enter : ix = & attached file / device getchar function
;         bc' = number of chars read thus far
;         de' = number of conversions done thus far
; exit  : bc' = number of chars read thus far
;         de' = number of conversions done thus far
;          a  = input char
;         carry set if error on stream (EOF)
; uses  : af, exx

.stdio_getchar

   bit 0,(ix-2)                ; is an unget char available?
   jr z, readfromstream

   ld a,(ix-1)                 ; return unget char
   res 0,(ix-2)                ; unget char no longer available

   exx
   inc bc                      ; increase number of bytes read from stream
   exx

   or a                        ; no error
   ret
 
.readfromstream

   exx
   push bc
   push de
   call l_jpix
   pop de
   pop bc

   jr c, error
   inc bc                      ; increase number of bytes read from stream

.error

   exx
   ret
