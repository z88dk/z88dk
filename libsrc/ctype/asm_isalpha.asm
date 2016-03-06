; asm_isalpha

        SECTION code_clib

PUBLIC asm_isalpha

; determine if the char is in [A-Za-z]

; enter : a = char
; exit  : carry = not alphabetic
; uses  : f

.asm_isalpha

   cp 'A'
   ret c
   cp 'Z'+1
   ccf
   ret nc
   
   cp 'a'
   ret c
   cp 'z'+1
   ccf
   
   ret
