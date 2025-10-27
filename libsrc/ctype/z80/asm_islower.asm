
SECTION code_clib
SECTION code_ctype

PUBLIC asm_islower

asm_islower:

   ; determine if char is in [a-z

   
   ; enter : a = char
   ; exit  : carry if not lower
   ; uses  : f
   
   cp 'a'
   ret c
   
   cp 'z'+1
   ccf

   ret
