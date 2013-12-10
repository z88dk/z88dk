
XLIB l_eat_digits
LIB l_char2num

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
   jp l_eat_digits
