
SECTION code_clib
SECTION code_ctype

PUBLIC asm_tolower

asm_tolower:

   ; if char is in [A-Z] make it lower case

   ; enter : a = char
   ; exit  : a = lower case char
   ; uses  : af

   cp 'A'
   ret c
   
   cp 'Z'+1
   ret nc
   
   or $20
   ret
