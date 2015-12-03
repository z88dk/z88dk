
SECTION code_clib
SECTION code_string

PUBLIC __str_locate_nul

__str_locate_nul:

   ; enter : hl = char *s
   ;
   ; exit  : hl = ptr in s to terminating 0
   ;         bc = -(strlen + 1)
   ;          a = 0
   ;         carry reset
   ;
   ; uses  : af, bc, hl
   
   xor a
   ld c,a
   ld b,a
   cpir
   
   dec hl
   ret
