
SECTION code_clib
SECTION code_ctype

PUBLIC asm_isspace

asm_isspace:

   ; determine if char is whitespace

   ; enter : a = char
   ; exit  : carry reset if whitespace
   ; uses  : f

   cp ' '                      ; space
   ret z
   
   cp 9
   ret c
   
   cp 14
   ccf
   
   ret
