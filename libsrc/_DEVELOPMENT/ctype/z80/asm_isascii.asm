
SECTION code_clib
SECTION code_ctype

PUBLIC asm_isascii

asm_isascii:

   ; determine if char is 7-bit ascii
   
   ; enter : a = char
   ; exit  : carry set if ascii
   ; uses  : f
   
   cp 128
   ret
