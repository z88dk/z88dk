
SECTION code_clib
SECTION code_l

PUBLIC l_eat_ddigits

EXTERN asm_isdigit

l_eat_ddigits:

   ; advance buffer pointer past decimal digits
   ;
   ; enter : hl = char *
   ;
   ; exit  : hl = char * (points past digits)
   ;          a = non-matching char
   ;
   ; uses  : af, hl
   
   ld a,(hl)
   
   call asm_isdigit
   ret c
   
   inc hl
   jr l_eat_ddigits
