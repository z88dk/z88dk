; asm_iscntrl

PUBLIC asm_iscntrl

; determine if the char is in [A-Za-z]

; enter : a = char
; exit  : carry = not a control char
; uses  : f

.asm_iscntrl
   cp 127
   ccf
   ret z
   cp 32
   ccf
   ret
