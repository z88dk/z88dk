; asm_isbdigit

        SECTION code_clib

PUBLIC asm_isbdigit

; determine whether ascii char is a binary digit

; enter : a = char
; exit  : carry = not a binary digit
; uses  : f

.asm_isbdigit

   cp '0'
   ret c
   cp '1'+1
   ccf
   ret
