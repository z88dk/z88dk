; asm_isupper

        SECTION code_clib

PUBLIC asm_isupper

; determine if the char is in [A-Z]

; enter : a = char
; exit  : carry = not upper
; uses  : f

.asm_isupper

   cp 'A'
   ret c
   
   cp 'Z'+1
   ccf
   
   ret
