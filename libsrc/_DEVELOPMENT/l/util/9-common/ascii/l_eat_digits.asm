
SECTION code_clib
SECTION code_l

PUBLIC l_eat_digits

EXTERN l_char2num

l_eat_digits:

   ; advance buffer pointer past digits
   ;
   ; enter : hl = char *
   ;          c = base
   ;
   ; exit  : hl = char * (points past number)
   ;
   ; uses  : af, hl
   
   ld a,(hl)
   call l_char2num
   ret c
   
   cp c
   ret nc
   
   inc hl
   jr l_eat_digits
