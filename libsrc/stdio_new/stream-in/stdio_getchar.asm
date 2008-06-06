; stdio_getchar
; 05.2008 aralbrec

XLIB stdio_getchar
LIB l_jpix

INCLUDE "stdio.def"

; all character input from stream is read through this function
;
; enter : ix = FILE *
;         bc' = number of chars read thus far
;         de' = number of conversions done thus far
; exit  : bc' = number of chars read thus far
;         de' = number of conversions done thus far
;          a  = input char
;         carry set if error on stream (EOF)
; uses  : af, exx

.stdio_getchar

   bit 0,(ix+3)                ; is an unget char available?
   jr z, readfromstream

   ld a,(ix+4)                 ; return unget char
   res 0,(ix+3)                ; unget char no longer available

   exx
   inc bc                      ; increase number of bytes read from stream
   exx

   or a                        ; no error
   ret
 
.readfromstream

   exx
   push bc
   push de
   ld c,STDIO_SERVICE_GETCHAR
   call l_jpix
   pop de
   pop bc

   jr c, error
   inc bc                      ; increase number of bytes read from stream

.error

   exx
   ret
