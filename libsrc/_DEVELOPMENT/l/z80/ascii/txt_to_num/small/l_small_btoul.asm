
SECTION code_clib
SECTION code_l

PUBLIC l_small_btoul

l_small_btoul:

   ; ascii binary string to unsigned long
   ; whitespace is not skipped
   ; char consumption stops on overflow
   ;
   ; enter : de = char *buffer
   ;
   ; exit  : bc = & next char to interpret in buffer
   ;         dehl = unsigned result (0 on invalid input)
   ;         carry set on unsigned overflow
   ;
   ; uses  : af, bc, de, hl

   ld c,e
   ld b,d
   
   ld de,0
   ld l,e
   ld h,d
   
   dec bc
   push de
   push hl

loop:

   pop af
   pop af
   
   inc bc
   ld a,(bc)
   
   sub '0'
   ccf
   ret nc
   cp 2
   ret nc
   
   push de
   push hl
   
   rra
   adc hl,hl
   rl e
   rl d
   
   jr nc, loop
   
   pop hl
   pop de
   
   ret
