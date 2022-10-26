
SECTION code_clib
SECTION code_l

PUBLIC l_small_asr_dehl

EXTERN error_lznc, error_lmnc

l_small_asr_dehl:

   ; arithmetic shift right 32-bit signed long
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl >> a
   ;
   ; uses  : af, b, de, hl
   
   or a
   ret z
   
   cp 32
   jr nc, shift_infinite
   
   ld b,a
   ld a,e

shift_loop:

   sra d
   rra
   rr h
   rr l
   
   djnz shift_loop
   
   ld e,a
   ret

shift_infinite:

   bit 7,d

   jp z, error_lznc
   jp error_lmnc
