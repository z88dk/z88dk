
SECTION code_clib
SECTION code_stdlib

PUBLIC __dtoa_print_zeroes

__dtoa_print_zeroes:

   inc a

loop:

   dec a
   ret z
   
   ld (hl),'0'
   inc hl
   
   jr loop
