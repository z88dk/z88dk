
SECTION code_clib
SECTION code_stdlib

PUBLIC __strtod_exponent

EXTERN asm0_atoi, l_eat_ddigits

__strtod_exponent:

   ; hl = char *

   push bc
   
   call asm0_atoi
   
   ex de,hl                    ; de = decimal exponent
   call l_eat_ddigits          ; move hl past trailing digits
   
   pop bc

   ret
