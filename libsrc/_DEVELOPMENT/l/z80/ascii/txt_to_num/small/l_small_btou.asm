
SECTION code_clib
SECTION code_l

PUBLIC l_small_btou

l_small_btou:

   ; ascii binary string to unsigned integer
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *buffer
   ;
   ; exit  : de = & next char to interpret in buffer
   ;         hl = unsigned result (0 on invalid input)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, de, hl

   ld hl,0
   
   dec de
   push hl

loop:

   pop af
   
   inc de
   ld a,(de)
   
   sub '0'
   ccf
   ret nc
   cp 2
   ret nc
   
   push hl
   
   rra
   adc hl,hl
   
   jr nc, loop
   
   pop hl
   ret
   