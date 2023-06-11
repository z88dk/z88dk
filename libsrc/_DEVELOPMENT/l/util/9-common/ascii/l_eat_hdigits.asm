
SECTION code_clib
SECTION code_l

PUBLIC l_eat_hdigits

EXTERN asm_isxdigit

l_eat_hdigits:

   ; advance buffer pointer past decimal digits
   ;
   ; enter : hl = char *
   ;
   ; exit  : hl = char * (points past digits)
   ;          a = non-matching char
   ;
   ; uses  : af, hl
   
   ld a,(hl)
   
   call asm_isxdigit
   ret c
   
   inc hl
   jr l_eat_hdigits
