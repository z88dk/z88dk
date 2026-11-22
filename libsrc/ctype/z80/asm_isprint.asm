
SECTION code_clib
SECTION code_ctype

PUBLIC asm_isprint

asm_isprint:

   ; determine if char is in 32..126
   
   ; enter : a = char
   ; exit  : carry if not isprint
   ; uses  : f
   
   cp 32
   ret c
   
   cp 127
   ccf
   
   ret
