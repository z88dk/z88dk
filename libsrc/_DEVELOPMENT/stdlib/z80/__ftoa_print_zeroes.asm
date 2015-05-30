
SECTION code_stdlib

PUBLIC __ftoa_print_zeroes

__ftoa_print_zeroes:

   or a
   ret z
   
   ld (hl),'0'
   inc hl
   
   dec a
   jr __ftoa_print_zeroes
