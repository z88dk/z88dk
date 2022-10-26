
SECTION code_clib
SECTION code_l

PUBLIC l_fast_asr_dehl

EXTERN l0_fast_asr_hl
EXTERN error_lznc, error_lmnc

l_fast_asr_dehl:

   ; arithmetic shift right 32-bit signed long
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl >> a
   ;
   ; uses  : af, bc, de, hl
   
   or a
   ret z
   
   cp 32
   jr nc, shift_infinite
   
   ld c,8
   sub c
   
   jr c, fine_shift

   ld l,h
   ld h,e
   ld e,d
   
   ld b,a
   rl d
   sbc a,a
   ld d,a
   ld a,b

   sub c
   jr c, fine_shift
   
   ld l,h
   ld h,e
   ld e,d

   sub c
   jp c, l0_fast_asr_hl
   
   ld l,h
   ld h,e
   
   sub c
   jp c, l0_fast_asr_hl
   
   ld l,h
   ret

fine_shift:

   add a,c
   ret z
   
   ld b,a
   ld a,e

fine_shift_loop:

   sra d
   rra
   rr h
   rr l
   
   djnz fine_shift_loop
   
   ld e,a
   ret

shift_infinite:

   bit 7,d
   
   jp z, error_lznc
   jp error_lmnc
