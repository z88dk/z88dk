
SECTION code_clib
SECTION code_ctype

PUBLIC asm_isdigit

asm_isdigit:

   ; determine if char is a decimal digit
   
   ; enter : a = char
   ; exit  : carry set if not decimal digit
   ; uses  : f
   
   cp '0'
   ret c
   
   cp '9'+1
   ccf
   ret
