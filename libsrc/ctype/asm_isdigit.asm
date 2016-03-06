; asm_isdigit

        SECTION code_clib

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
