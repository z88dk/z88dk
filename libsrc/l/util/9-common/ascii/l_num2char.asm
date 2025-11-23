
SECTION code_clib
SECTION code_l

PUBLIC l_num2char

l_num2char:

   ; translate single digit number to uppercase ascii char
   ; ** case must be consistent with l_utoh
   ;
   ; enter : a = digit 0-36
   ;
   ; exit  : a = uppercase ascii char representation
   ;
   ; uses  : af
   
   cp 10
   jr nc, alpha
   
   add a,'0'
   ret

alpha:

   add a,'A'-10
   ret
