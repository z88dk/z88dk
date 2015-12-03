
SECTION code_clib
SECTION code_stdlib

PUBLIC __dtoa_print_zeroes

__dtoa_print_zeroes:

   or a
   ret z
   
   ld (hl),'0'
   inc hl
   
   dec a
   jr __dtoa_print_zeroes
