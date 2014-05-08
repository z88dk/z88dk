
PUBLIC l_small_lsr_hl

l_small_lsr_hl:

   ; logical shift right 16-bit unsigned int
   ;
   ; enter : hl = 16-bit number
   ;          a = shift amount
   ;
   ; exit  : hl = hl >> a
   ;
   ; uses  : af, b, hl

   or a
   ret z
   
   ld b,a
   ld a,l

shift_loop:

   srl h
   rra
   
   djnz shift_loop
   
   ld l,a
   ret
