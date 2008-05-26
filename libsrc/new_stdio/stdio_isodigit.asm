; stdio_isodigit
; 05.2008 aralbrec

XLIB stdio_isodigit

; determine whether ascii char is an octal digit

; enter : a = char
; exit  : carry = not a digit
; uses  : f

.stdio_isodigit

   cp '0'
   ret c
   cp '7'+1
   ccf
   ret
