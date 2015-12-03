
SECTION code_clib
SECTION code_ctype

PUBLIC asm_isalnum

asm_isalnum:

   ; determine if char is in [0-9A-Za-z

   
   ; enter : a = char
   ; exit  : carry set if not alphanumeric
   ; uses  : f
   
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
