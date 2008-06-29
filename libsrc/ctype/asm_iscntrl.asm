; asm_iscntrl

XLIB asm_iscntrl

; determine if the char is in [A-Za-z]

; enter : a = char
; exit  : carry = not a control char
; uses  : f

.asm_iscntrl

   cp 32
   ccf
   ret
