
SECTION code_clib
SECTION code_ctype

PUBLIC asm_isxdigit

asm_isxdigit:

   ; determine if character is a hex digit
   
   ; enter : a = char
   ; exit  : carry set if not hex digit
   ; uses  : f
   
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
