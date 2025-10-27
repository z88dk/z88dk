
SECTION code_clib
SECTION code_ctype

PUBLIC asm_isalpha

asm_isalpha:

   ; determine if char is in [A-Za-z

   
   ; enter : a = char
   ; exit  : carry set if not alphabetic
   ; uses  : f
   
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
