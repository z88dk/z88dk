
SECTION code_clib
SECTION code_ctype

PUBLIC asm_toupper

asm_toupper:

   ; if char is in [a-z] make it upper case

   ; enter : a = char
   ; exit  : a = upper case char
   ; uses  : af

   cp 'a'
   ret c
   
   cp 'z'+1
   ret nc
   
   and $df
   ret
