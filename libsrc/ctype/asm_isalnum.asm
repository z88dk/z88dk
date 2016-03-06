; asm_isalnum

	SECTION	code_clib

PUBLIC asm_isalnum

; determine if the char is in [0-9A-Za-z]

; enter : a = char
; exit  : carry = not alphanumeric
; uses  : f

.asm_isalnum

   cp '0'
   ret c
   cp '9'+1
   ccf
   ret nc
   
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

