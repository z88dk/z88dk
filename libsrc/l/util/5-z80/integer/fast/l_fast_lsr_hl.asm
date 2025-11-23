
SECTION code_clib
SECTION code_l

PUBLIC l_fast_lsr_hl, l0_fast_lsr_hl

l_fast_lsr_hl:

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
   ld b,8
   
   sub b
   jr c, fine_shift
   
   ld l,h
   ld h,0
      
   sub b
   jr c, fine_shift
   
   ld l,h
   ret

l0_fast_lsr_hl:
fine_shift:

   add a,b
   ret z
   
   ld b,a
   ld a,l

fine_shift_loop:

   srl h
   rra
   
   djnz fine_shift_loop
   
   ld l,a
   ret
