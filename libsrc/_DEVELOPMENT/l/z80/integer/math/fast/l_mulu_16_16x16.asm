
XLIB l_mulu_16_16x16

LIB l_mulu_24_16x8, error_mulu_overflow_mc

l_mulu_16_16x16:

   ; unsigned multiplication of two 16-bit
   ; multiplicands into a 16-bit product
   ;
   ; error reported on overflow
   ;
   ; enter : de = 16-bit multiplicand
   ;         hl = 16-bit multiplicand
   ;
   ; exit  : success
   ;
   ;             a = 0
   ;            hl = 16-bit product
   ;            carry reset
   ;
   ;         unsigned overflow
   ;
   ;            hl = $ffff = UINT_MAX
   ;            carry set, errno = ERANGE
   ;
   ; uses  : af, c, de, hl

   ; try to reduce the multiplication

   inc d
   dec d
   jr z, reduce_0
   
   inc h
   dec h
   jp nz, error_mulu_overflow_mc  ; if both de and hl > 255

   ex de,hl
   
reduce_0:

   ;  e = 8-bit multiplicand
   ; hl = 16-bit multiplicand
   
   call l_mulu_24_16x8
   
   or a
   ret z                       ; if result confined to hl

   jp error_mulu_overflow_mc
