
SECTION code_clib
SECTION code_ctype

PUBLIC asm_isodigit

asm_isodigit:

   ; determine if char is an octal digit
   
   ; enter : a = char
   ; exit  : carry if not an octal digit
   ; uses  : f
   
   cp '0'
   ret c
   
   cp '7'+1
   ccf
   
   ret
