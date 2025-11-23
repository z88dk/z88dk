
SECTION code_clib
SECTION code_l

PUBLIC l_fast_lsl_hl

l_fast_lsl_hl:

   ; logical shift left 16-bit number
   ;
   ; enter : hl = 16-bit number
   ;          a = shift amount
   ;
   ; exit  : hl = hl << a
   ;
   ; uses  : af, b, hl

   or a
   ret z
   ld b,8
   
   sub b
   jr c, fine_shift

   ld h,l
   ld l,0
   
   sub b
   jr c, fine_shift

   ld h,l
   ret

fine_shift:

   add a,b
   ld b,a

fine_shift_loop:

   add hl,hl
   djnz fine_shift_loop

   ret
