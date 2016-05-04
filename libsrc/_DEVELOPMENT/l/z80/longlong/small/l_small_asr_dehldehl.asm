
SECTION code_clib
SECTION code_l

PUBLIC l_small_asr_dehldehl

EXTERN l_asr_dehl
EXTERN error_llmnc, error_llznc

l_small_asr_dehldehl:

   ; arithmetic shift right 64-bit signed long
   ;
   ; enter : dehl'dehl = 64-bit number
   ;                 a = shift amount
   ;
   ; exit  : dehl'dehl = dehl'dehl >> a
   ;
   ; uses  : af, b, de, hl, de', hl'
   
   or a
   ret z
   
   cp 64
   jr nc, shift_infinite

   cp 32
   jr c, shift
   
   ; 32-bit shift
   
   sub 32
   
   exx
   
   call l_asr_dehl
   ld a,d
   
   exx
   
   add a,a
   sbc a,a
   
   ld d,a
   ld e,a
   ld h,a
   ld l,a
   
   exx
   ret

shift:
   
   ld b,a
   ld a,e

shift_loop:

   exx
   
   sra d
   rr e
   rr h
   rr l
   
   exx
   
   rr d
   rra
   rr h
   rr l
   
   djnz shift_loop
   
   ld e,a
   ret

shift_infinite:

   exx
   bit 7,d
   exx
   
   jp z, error_llznc
   jp error_llmnc
