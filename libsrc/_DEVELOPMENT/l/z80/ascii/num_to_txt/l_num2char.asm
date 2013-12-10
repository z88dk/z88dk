
XLIB l_num2char

l_num2char:

   ; translate single digit number to lowercase ascii char
   ; ** case must be consistent with l_utoh
   ;
   ; enter : a = digit 0-36
   ;
   ; exit  : a = lowercase ascii char representation
   ;
   ; uses  : af
   
   cp 10
   jr nc, alpha
   
   add a,'0'
   ret

alpha:

   add a,'a'-10
   ret
