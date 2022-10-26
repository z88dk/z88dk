
SECTION code_clib
SECTION code_l

PUBLIC l_eat_sign

l_eat_sign:

   ; consume leading + or - sign
   ;
   ; enter : hl = char *
   ;
   ; exit  : hl = char * (past leading sign)
   ;          a = examined char
   ;         carry = minus sign met
   ;
   ; uses  : af, hl
   
   ld a,(hl)
   inc hl
   
   cp '+'
   ret z
   
   cp '-'
   scf
   ret z

   dec hl
   or a
   ret
