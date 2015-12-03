
SECTION code_clib
SECTION code_l

PUBLIC l_char2num

EXTERN asm_isalpha

l_char2num:

   ; translate char in [0-9A-Za-z] to number
   ;
   ; enter : a = char
   ;
   ; exit  : a = number
   ;         carry set if char not in range
   ;
   ; uses  : af
   
   sub '0'
   ret c
   
   cp 10
   ccf
   ret nc
   
   add a,'0'

   call asm_isalpha
   ret c
      
   and $df
   sub 'A'-10
   ret
