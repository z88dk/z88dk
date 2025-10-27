
; 2000 djm
; 2014 aralbrec - special case for 8-bit divisor

SECTION code_clib
SECTION code_math

PUBLIC l_small_divu_16_16x16, l0_small_divu_16_16x16
PUBLIC l_small_divu_16_16x8, l0_small_divu_16_16x8

EXTERN error_divide_by_zero_mc

   ; entry point to swap dividend / divisor

   ex de,hl

l_small_divu_16_16x16:

   ; unsigned division of 16-bit numbers
   ;
   ; enter : hl = 16-bit dividend
   ;         de = 16-bit divisor
   ;
   ; exit  : success
   ;
   ;            hl = quotient
   ;            de = remainder
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;            hl = $ffff = UINT_MAX
   ;            de = dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc, de, hl

   ld a,d
   or e
   jr z, divide_zero

l0_small_divu_16_16x16:

   ; skip divide by zero check

   inc d
   dec d
   jr z, l0_small_divu_16_16x8

divisor_sixteen_bit:

   ; result of the first eight iterations are known
   ; so let's initialize as if that already happened

   ld a,l
   ld l,h
   ld h,0
   ld b,8

loop_16_0:

   rla
   adc hl,hl
   
   sbc hl,de
   jr nc, loop_16_1
   add hl,de

loop_16_1:

   ccf
   djnz loop_16_0

   rla
   
   ld d,b
   ld e,a
   ex de,hl

   or a
   ret

   ; entry point to swap dividend / divisor
   
   ex de,hl

l_small_divu_16_16x8:

   ; unsigned division of 16-bit by 8-bit
   ;
   ; enter : hl = 16-bit dividend
   ;          e = 8-bit divisor
   ;
   ; exit  : success
   ;
   ;            hl = quotient
   ;            de = remainder
   ;            carry reset
   ;
   ;         divide by zero
   ;
   ;            hl = $ffff = UINT_MAX
   ;            de = dividend
   ;            carry set, errno = EDOM
   ;
   ; uses  : af, bc, de, hl

   inc e
   dec e
   jr z, divide_zero

l0_small_divu_16_16x8:

   xor a
   ld d,a
   ld b,16

loop_8_0:

   add hl,hl
   rla
   jr c, loop_8_2
   
   cp e
   jr c, loop_8_1

loop_8_2:

   sub e
   inc l

loop_8_1:

   djnz loop_8_0

   ld e,a
   
   or a
   ret

divide_zero:

   ex de,hl
   jp error_divide_by_zero_mc
