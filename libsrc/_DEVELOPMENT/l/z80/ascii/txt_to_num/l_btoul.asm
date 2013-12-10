
XLIB l_btoul
LIB l_btou

l_btoul:

   ; ascii binary string to unsigned long
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *buffer
   ;
   ; exit  : bc = & next char to interpret in buffer
   ;         dehl = unsigned result (0 on invalid input, and $ffffffff on overflow)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, bc, de, hl

   call l_btou                 ; try to do it in 16 bits
   
   ld c,e
   ld b,d
   
   ld de,0
   ret nc                      ; was 16 bits
   
   ; 32 bit loop
   
   inc e

loop:

   ld a,(bc)
   
   ; inlined isbdigit
   
   sub '0'
   ccf
   ret nc
   cp 2
   ret nc
   
   inc bc
   
   rra
   adc hl,hl
   rl e
   rl d
   
   jp nc, loop
   ret
   