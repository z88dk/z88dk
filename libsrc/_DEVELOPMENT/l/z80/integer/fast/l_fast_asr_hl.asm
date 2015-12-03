
SECTION code_clib
SECTION code_l

PUBLIC l_fast_asr_hl, l0_fast_asr_hl

l_fast_asr_hl:

   ; arithmetic shift right 16-bit signed int
   ;
   ; enter : hl = 16-bit number
   ;          a = shift amount
   ;
   ; exit  : hl = hl >> a
   ;
   ; uses  : af, bc, hl

   or a
   ret z
   
   ld c,8
   
   sub c
   jr c, fine_shift
   
   ld l,h
   
   ld b,a
   rl h
   sbc a,a
   ld h,a
   ld a,b
   
   sub c
   jr c, fine_shift
   
   ld l,h
   ret

l0_fast_asr_hl:
fine_shift:

   add a,c
   ret z
   
   ld b,a
   ld a,l

fine_shift_loop:

   sra h
   rra
   
   djnz fine_shift_loop
   
   ld l,a
   ret
