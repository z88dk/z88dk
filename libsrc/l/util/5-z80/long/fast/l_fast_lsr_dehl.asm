
SECTION code_clib
SECTION code_l

PUBLIC l_fast_lsr_dehl

EXTERN l0_fast_lsr_hl

l_fast_lsr_dehl:

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
   
   sub b
   jr c, fine_shift

   ld l,h
   ld h,e
   ld e,d
   ld d,0

   sub b
   jr c, fine_shift
   
   ld l,h
   ld h,e
   ld e,d

   sub b
   jp c, l0_fast_lsr_hl
   
   ld l,h
   ld h,e
   
   sub b
   jp c, l0_fast_lsr_hl
   
   ld l,h
   ret

fine_shift:

   add a,b
   ret z
   
   ld b,a
   ld a,e

fine_shift_loop:

   srl d
   rra
   rr h
   rr l
   
   djnz fine_shift_loop
   
   ld e,a
   ret
