
SECTION code_clib
SECTION code_ctype

PUBLIC asm_isblank

asm_isblank:

   ; determine if char is tab or space
   
   ; enter : a = char
   ; exit  : z flag set if blank
   ; uses  : f
   
   cp ' '
   ret z
   
   cp 9
   ret
