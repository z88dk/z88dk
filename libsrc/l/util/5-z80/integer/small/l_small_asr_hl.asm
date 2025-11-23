
SECTION code_clib
SECTION code_l

PUBLIC l_small_asr_hl
EXTERN error_znc, error_mnc

l_small_asr_hl:

   ; arithmetic shift right 16-bit signed int
   ;
   ; enter : hl = 16-bit number
   ;          a = shift amount
   ;
   ; exit  : hl = hl >> a
   ;
   ; uses  : af, b, hl

   or a
   ret z
   
   cp 16
   jr nc, shift_infinite
   
   ld b,a
   ld a,l

shift_loop:

   sra h
   rra
   
   djnz shift_loop
   
   ld l,a
   ret

shift_infinite:

   bit 7,h
   
   jp z, error_znc
   jp error_mnc
