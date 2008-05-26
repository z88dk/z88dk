; stdio_isspace
; 05.2008 aralbrec

XLIB stdio_isspace

; determine whether ascii char is a whitespace char

; enter : a = char
; exit  : z = whitespace, nz = not whitespace
; uses  : f

.stdio_isspace

   cp ' '
   ret z
   cp 7
   ret z
   cp 10
   ret z
   cp 13
   ret
