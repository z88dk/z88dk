
XLIB l_fast_mulu_8_8x8

LIB l_fast_mulu_16_8x8, error_mulu_overflow_mc

l_fast_mulu_8_8x8:

   ; unsigned multiplication of two 8-bit
   ; multiplicands into a sixteen bit product
   ;
   ; error reported on overflow
   ;
   ; enter : l = 8-bit multiplicand
   ;         e = 8-bit multiplicand
   ;
   ; exit  : a = 0
   ;         d = 0
   ;
   ;         success
   ;
   ;            h = 0
   ;            l = 8-bit product
   ;            carry reset
   ;
   ;         unsigned overflow
   ;
   ;            h = $ff
   ;            l = $ff = UCHAR_MAX
   ;            carry set, errno = ERANGE
   ;
   ; uses  : af, b, de, hl

   call l_fast_mulu_16_8x8
   
   inc h
   dec h
   ret z
   
   jp error_mulu_overflow_mc
