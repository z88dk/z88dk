
SECTION code_clib
SECTION code_l

PUBLIC l_fast_btou

l_fast_btou:

   ; ascii binary string to unsigned integer
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *buffer
   ;
   ; exit  : de = & next char to interpret in buffer
   ;         hl = unsigned result (0 on invalid input, and % $ffff on overflow)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, de, hl

   ld hl,0

loop:

   ld a,(de)
   
   ; inlined isbdigit
   
   sub '0'
   ccf
   ret nc
   cp 2
   ret nc
   
   inc de
   
   rra
   adc hl,hl
   
   jr nc, loop
   ret
