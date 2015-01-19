; asm_isdigit

PUBLIC asm_isdigit

; determine whether ascii char is a decimal digit

; enter : a = char
; exit  : carry = not a digit
; uses  : f

.asm_isdigit

   cp '0'
   ret c
   cp '9'+1
   ccf
   ret
