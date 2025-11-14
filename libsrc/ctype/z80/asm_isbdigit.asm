
SECTION code_clib
SECTION code_ctype

PUBLIC asm_isbdigit

asm_isbdigit:

   ; determine if char is a binary digit
   
   ; enter : a = char
   ; exit  : z flag if binary digit
   ; uses  : f
   
   cp '0'
   ret z
   
   cp '1'
   ret
