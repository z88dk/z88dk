
SECTION code_clib
SECTION code_l

PUBLIC l_fast_lsl_dehl

l_fast_lsl_dehl:

   ; logical shift left 32-bit number
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl << a
   ;
   ; uses  : af, b, de, hl

   or a
   ret z
   ld b,8
   
   sub b
   jr c, fine_shift
   
   ld d,e
   ld e,h
   ld h,l
   ld l,0
   
   sub b
   jr c, fine_shift
   
   ld d,e
   ld e,h
   ld h,l
   
   sub b
   jr c, fine_shift
   
   ld d,e
   ld e,h
   
   sub b
   jr c, fine_shift
   
   ld d,e
   ret

fine_shift:

   add a,b
   ret z
   
   ld b,a
   ld a,e

fine_shift_loop:

   add hl,hl
   rla
   rl d
   
   djnz fine_shift_loop
   
   ld e,a
   ret
