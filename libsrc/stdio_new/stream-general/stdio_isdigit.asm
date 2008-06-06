; stdio_isdigit
; 05.2008 aralbrec

XLIB stdio_isdigit

; determine whether ascii char is a decimal digit

; enter : a = char
; exit  : carry = not a digit
; uses  : f

.stdio_isdigit

   cp '0'
   ret c
   cp '9'+1
   ccf
   ret
