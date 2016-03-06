; asm_isodigit

        SECTION code_clib

PUBLIC asm_isodigit

; determine whether ascii char is an octal digit

; enter : a = char
; exit  : carry = not an octal digit
; uses  : f

.asm_isodigit

   cp '0'
   ret c
   cp '7'+1
   ccf
   ret
