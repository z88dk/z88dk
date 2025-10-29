
SECTION code_clib
SECTION code_ctype

PUBLIC asm_iscntrl

asm_iscntrl:

   ; determine if char is 127 or <32, ie non-printable ascii
   
   ; enter : a = char
   ; exit  : carry if a control char
   ; uses  : f
   
   cp 127
   ccf
   ret z
   
   cp 32
   ret
