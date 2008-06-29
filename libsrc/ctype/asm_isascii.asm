; asm_isascii

XLIB asm_isascii

; determine if the char is an ascii char

; enter : a = char
; exit  : carry = not ascii
; uses  : f

.asm_isascii

   rlca
   rrca
   ret
