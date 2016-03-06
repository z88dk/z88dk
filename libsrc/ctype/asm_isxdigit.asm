; asm_isxdigit

        SECTION code_clib

PUBLIC asm_isxdigit

; determine whether ascii char is a hexadecimal digit

; enter : a = char
; exit  : carry = not a hex digit
; uses  : f

.asm_isxdigit

   cp '0'
   ret c
   cp '9'+1
   ccf
   ret nc
   
   cp 'A'
   ret c
   cp 'F'+1
   ccf
   ret nc
   
   cp 'a'
   ret c
   cp 'f'+1
   ccf
   
   ret
