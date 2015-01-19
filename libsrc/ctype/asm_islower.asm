; asm_islower

PUBLIC asm_islower

; determine if the char is in [a-z]

; enter : a = char
; exit  : carry = not lower
; uses  : f

.asm_islower

   cp 'a'
   ret c
   
   cp 'z'+1
   ccf
   
   ret
