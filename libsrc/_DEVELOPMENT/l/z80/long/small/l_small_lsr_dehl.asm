
PUBLIC l_small_lsr_dehl

l_small_lsr_dehl:

   ; logical shift right 32-bit unsigned long
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl >> a
   ;
   ; uses  : af, b, de, hl

   or a
   ret z
   
   ld b,8
   ld a,e

shift_loop:

   srl d
   rra
   rr h
   rr l
   
   djnz shift_loop
   
   ld e,a
   ret
