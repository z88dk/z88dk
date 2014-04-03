
XLIB l_fast_mulu_32_32x32

LIB l_fast_mulu_40_32x8, l0_fast_mulu_40_32x8, l0_fast_mulu_32_24x8
LIB error_mulu_overflow_mc, l_fast_mulu_32_16x16, l_fast_mulu_32_24x16

l_fast_mulu_32_32x32:

   ; unsigned multiplication of two 32-bit
   ; multiplicands into a 32-bit product
   ;
   ; error reported on overflow
   ;
   ; enter : dehl = 32-bit multiplicand
   ;         dehl'= 32-bit multiplicand
   ;
   ; exit  : success
   ;
   ;            dehl = 32-bit product
   ;            carry reset
   ;
   ;         unsigned overflow
   ;
   ;            dehl = $ffffffff = ULONG_MAX
   ;            carry set, errno = ERANGE
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ; try to reduce multiplication
   
   inc d
   dec d
   jr nz, _24b_x               ; 25 to 32 bits

   inc e
   dec e
   jr nz, _16b_x               ; 17 to 24 bits

   inc h
   dec h
   jr nz, _8b_x                ; 9 to 16 bits

_8_32:

   ; dehl' * l

   ld a,l
   exx

   call l_fast_mulu_40_32x8
   
   or a
   ret z

overflow:
   
   call error_mulu_overflow_mc
   
   ld e,l
   ld d,h
   
   ret

_24b_x:

   ; dehl * dehl'

   exx
   
   inc d
   dec d
   jr nz, overflow             ; 24b_24b = 48b

   inc e
   dec e
   jr nz, overflow             ; 24b_16b = 40b
   
   inc h
   dec h
   jr nz, overflow             ; 24b_8b = 32b

_32_8:

   ; l * dehl'
   
   ld a,l
   exx
   
   call l0_fast_mulu_40_32x8
   
   or a
   ret z

   jr overflow

_16b_x:

   ; ehl * dehl'

   exx
   
   inc d
   dec d
   jr nz, overflow             ; 16b_24b = 40b
   
   inc e
   dec e
   jr nz, overflow             ; 16b_16b = 32b

   inc h
   dec h
   jr nz, _24_16

_24_8:

   ; ehl' * l

   ld a,l
   exx
   
   jp l0_fast_mulu_32_24x8

_8b_x:

   ; hl * dehl'

   exx
   
   inc d
   dec d
   jr nz, overflow             ; 8b_24b = 32b
   
   inc e
   dec e
   jr z, _16_16
   
   ; hl' * ehl

   exx

_24_16:

   ; ehl' * hl

   push hl
   exx
   pop bc
   
   jp l_fast_mulu_32_24x16

_16_16:

   ; hl' * hl
   
   push hl
   exx
   pop de
   
   jp l_fast_mulu_32_16x16
