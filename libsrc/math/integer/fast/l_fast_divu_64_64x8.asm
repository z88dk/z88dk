
; 2016 aralbrec

SECTION code_clib
SECTION code_math

PUBLIC l_fast_divu_64_64x8
PUBLIC l0_fast_divu_64_64x8

EXTERN error_llmc, error_divide_by_zero_mc

l_fast_divu_64_64x8:

   ; unsigned division of a 64-bit number
   ; by an 8-bit number
   ;
   ; enter : dehl'dehl = 64-bit dividend
   ;                 c = 8-bit divisor
   ;
   ; exit  : success
   ;
   ;            dehl'dehl = 64-bit quotient
   ;                    a = remainder
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;            dehl'dehl = ULLONG_MAX
   ;            (dividend is lost)
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, b, de, hl, de', hl'

   ld a,c
   or a
   jr z, divide_by_zero
   
l0_fast_divu_64_64x8:

   xor a
   ld b,64

loop_11:

   add hl,hl
   rl e
   rl d
   exx
   adc hl,hl
   rl e
   rl d
   exx
   
   rla
   jr c, loop_02
   
   cp c
   jr c, loop_03

loop_02:

   sub c
   inc l

loop_03:

   djnz loop_11
   
   or a
   ret

divide_by_zero:

   call error_llmc
   jp error_divide_by_zero_mc
