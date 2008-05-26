; stdio_isbdigit
; 05.2008 aralbrec

XLIB stdio_isbdigit

; determine whether ascii char is a decimal digit

; enter : a = char
; exit  : carry = not a digit
; uses  : f

.stdio_isbdigit

   cp '0'
   ret c
   cp '1'+1
   ccf
   ret
